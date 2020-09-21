$versions{'PlugnPaySS2-order_lib.pl'} = '06.6.00.0003';
#####################################################################
#
# AgoraCart and all associated files, except where noted, are
# Copyright 2001 to Present jointly by K-Factor Technologies, Inc.
# and by C E Mayo (aka Mister Ed) at AgoraCart.com & K-Factor.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This copyright notice may not be removed or altered in any way.
#
#######################################################################
#                    Order Form Definition Variables
#######################################################################

$gateway_button_name{'PlugnPaySS2'} = 'PlugnPay.com';

$sc_order_response_vars{'PlugnPaySS2'} = 'pi_response_status';
add_codehook( 'printSubmitPage', 'print_PnPSS2_SubmitPage' );
add_codehook( 'set_form_required_fields', 'PnPSS2_fields' );
add_codehook( 'gateway_response', 'check_for_PnPSS2_response' );

#######################################################################

sub PnPSS2_check_and_load {
  local ($myname) = 'PlugnPaySS2';
  if ( $myname ne $sc_gateway_name ) {
    require_supporting_libraries( __FILE__, __LINE__, "$sc_userpay_conf_dir/$myname-user_lib.pl" );
  }
}

#######################################################################

sub check_for_PnPSS2_response {
  if ( ($form_data{'pi_response_status'} == 'success') && $form_data{'pt_account_code_1'} && $form_data{'pt_account_code_2'} && $mc_mgr_gateways_enabled =~ /PlugnPaySS2/i) {
    $cart_id = $form_data{'pt_account_code_1'};
    PnPSS2_check_and_load();
    set_sc_cart_path();
    load_order_libs();
    load_cart_libs();
    codehook('PnPSS2_order');
    if ( $sc_header_printed ne 1 ) {
      &print_agora_http_headers();
    }
    process_PnPSS2_Order();
    call_exit();
  }
}

#######################################################################

sub PnPSS2_fields {

  local ($myname) = 'PlugnPaySS2';

  if ( !( $form_data{'gateway'} eq $myname ) ) { return; }

  set_order_form_array();

  @sc_order_form_required_fields = ('Ecom_ShipTo_Postal_City', 'Ecom_ShipTo_Postal_StateProv', 'Ecom_ShipTo_Postal_PostalCode', 'Ecom_BillTo_Online_Email', 'Ecom_ShipTo_Postal_CountryCode');

  # override if in donation mode
  if ( $sc_donation_mode eq 'yes' && $sc_donation_orderform_name  ) {
    @sc_order_form_required_fields = @sc_donation_form_required_fields;
  }

  if ( $PnPSS2_display_checkout_tos =~ /yes/i ) {
    push( @sc_order_form_required_fields, 'Ecom_tos' );
  }

  # use this codehook to change the above arrays for required fields and such
  codehook('PlugnPay_fields_bottom');
}

#######################################################################
# load the customer info ...

sub PnPSS2_order_form_prep {
  PnPSS2_check_and_load();
  if ( $PnPSS2_form_prep == 0 ) {
    if ( -f "$sc_verify_order_path" ) {
      read_verify_file();
    }
    else {
      codehook('load_customer_info');
    }
    $PnPSS2_form_prep = 1;
  }
  return '';
}

#######################################################################

sub PnPSS2_table_setup {

  #
  # To use this, put this in the email_text in the manager for HTML:
  #
  #	<!--agorascript-pre
  #	  return $PlugnPay_cart_table;
  #	-->
  #
  # or for text in an email:
  #
  #	<!--agorascript-pre
  #	  return $PlugnPay_prod_in_cart;
  #	-->
  #

  local ( @my_cart_fields, $my_cart_row_number, $result );
  local ( $count, $price, $quantity, $total_cost, $total_qty ) = 0;
  local ( $name, $cost );

  $result   = q{};
  open(CART,'<',"$sc_cart_path") || file_open_error("$sc_cart_path", 'display_cart_contents_in_header',__FILE__, __LINE__ );
  while (<CART>) {
    $count++;
    chop;
    @my_cart_fields = split( /\|/, $_ );
    $my_cart_row_number = pop(@my_cart_fields);
    push( @my_cart_fields, $my_cart_row_number );
    $quantity   = $my_cart_fields[0];
    $price      = $my_cart_fields[$sc_cart_index_of_price_after_options];
    $name       = $my_cart_fields[ $cart{'name'} ];
    $name       = substr( $name, 0, 35 );
    $cost       = format_price( $quantity * $price );
    $total_cost = $total_cost + $quantity * $price;
    $total_qty  = $total_qty + $quantity;
    $options    = $my_cart_fields[ $cart{'options'} ];
    $options =~ s/<br>/ /g;

    # no longer takes HTML table tags. Also does not accept br, div, and styling attributes.
    # Modified to title and plain text for cart items by Mister Ed, May 5, 2020.
    if ( $result eq '' ) {
      $result .= "<h3>Items Ordered:</h3>";
      $PlugnPay_prod_in_cart .= "  --PRODUCT INFORMATION--\n\n";
    }
    $result .= "<h5>$quantity &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $sc_money_symbol $cost</h5>";
    $PlugnPay_prod_in_cart .= cart_textinfo(*my_cart_fields);
  } # End of while (<CART>)
  close(CART);
  if ( $result ne '' ) {
    $result .= "</table></td></tr></table>\n";
  }

  # use this to change $result
  codehook('PnPSS2_table_setup_bottom');

  $PlugnPay_cart_table = $result;
}

#######################################################################

sub print_PnPSS2_SubmitPage {

  local ( $invoice_number, $customer_number, $displayTotal );
  local ( $zemail_text );
  local ($myname) = 'PlugnPaySS2';
  local ( $HREF_FIELDS ) = make_hidden_fields();
  local ( $my_message, $my_desc );
  local ( $additional_form_thingies ) = q{};
  local ( $PlugnPay_prod_in_cart ) = q{};
  local ( $PlugnPay_cart_table )   = q{};
  my ($tempbodytags) = q{};

  if ( !( $form_data{'gateway'} eq $myname ) || $mc_mgr_gateways_enabled !~ /$myname/i ) { return; }
  &PnPSS2_check_and_load();

  $displayTotal = display_price($authPrice);

  $invoice_number  = $current_verify_inv_no;
  $customer_number = $cart_id;
  $customer_number =~ s/_/./g;
  &PnPSS2_table_setup();
  $my_desc = script_and_substitute($PnPSS2_pt_order_classifier);

  $sc_display_checkout_tos = $PnPSS2_display_checkout_tos;

  $my_message = script_and_substitute($PnPSS2_verify_message);

  if ( $PnPSS2_pb_post_auth =~ /yes/ ) {
    $PnPSS2_sale_mode = qq~<input type="hidden" name="pb_post_auth" value="yes">~;
  }

  # use this to add hidden form elements to submit to PlugnPay
  codehook('PnPSS2_additional_form_elements');

  my $temp_URL = $sc_ssl_location_url2 . '?gateresponse=PnPSS2&cart_id=' . $customer_number;

  print <<ENDOFTEXT;
<form method="post" action="https://pay1.plugnpay.com/pay/">

<input type="hidden" name="pt_transaction_amount" value="$authPrice">
<input type="hidden" name="pt_shipping_amount" value="$zfinal_shipping">
<input type="hidden" name="pt_discount" value="$zfinal_discount">
<input type="hidden" name="pt_tax_amount" value="$zfinal_sales_tax">

<input type="hidden" name="pt_gateway_account" value="$PnPSS2_pt_gateway_account">
<input type="hidden" name="pt_order_classifier" value="$PnPSS2_pt_order_classifier">
<input type="hidden" name="pt_account_code_1" value="$invoice_number">
<input type="hidden" name="pt_account_code_2" value="$customer_number">
$PnPSS2_sale_mode
$additional_form_thingies
<input type="hidden" name="pb_success_url" value="$sc_ssl_location_url2">
<input type="hidden" name="pb_transition_type" value="hidden">
<input type="hidden" name="pt_client_identifier" value="AgoraCart_R66">
<!--Billing Address-->
<input type="hidden" name="pt_billing_name" value="$eform_data{'Ecom_BillTo_Postal_Name_First'} $eform_data{'Ecom_BillTo_Postal_Name_Last'}">
<input type="hidden" name="pt_billing_first_name" value="$eform_data{'Ecom_BillTo_Postal_Name_First'}">
<input type="hidden" name="pt_billing_last_name" value="$eform_data{'Ecom_BillTo_Postal_Name_Last'}">
<input type="hidden" name="pt_billing_address_1" value="$eform_data{'Ecom_BillTo_Postal_Street_Line1'}">
<input type="hidden" name="pt_billing_city" value="$eform_data{'Ecom_BillTo_Postal_City'}">
<input type="hidden" name="pt_billing_state" value="$eform_data{'Ecom_BillTo_Postal_StateProv'}">
<input type="hidden" name="pt_billing_postal_code" value="$eform_data{'Ecom_BillTo_Postal_PostalCode'}">
<input type="hidden" name="pt_billing_country" value="$eform_data{'Ecom_BillTo_Postal_CountryCode'}">
<input type="hidden" name="pt_billing_phone_number" value="$eform_data{'Ecom_BillTo_Telecom_Phone_Number'}">
<input type="hidden" name="pt_billing_email_address" value="$eform_data{'Ecom_BillTo_Online_Email'}">
<!--Shipping Address-->
<input type="hidden" name="pd_collect_shipping_information" value="no">
<input type="hidden" name="pt_shipping_name" value="$eform_data{'Ecom_ShipTo_Postal_Name_First'} $eform_data{'Ecom_ShipTo_Postal_Name_Last'}">
<input type="hidden" name="pt_shipping_first_name" value="$eform_data{'Ecom_ShipTo_Postal_Name_First'}">
<input type="hidden" name="pt_shipping_last_name" value="$eform_data{'Ecom_ShipTo_Postal_Name_Last'}">
<input type="hidden" name="pt_shipping_address_1" value="$eform_data{'Ecom_ShipTo_Postal_Street_Line1'}">
<input type="hidden" name="pt_shipping_city" value="$eform_data{'Ecom_ShipTo_Postal_City'}">
<input type="hidden" name="pt_shipping_state" value="$eform_data{'Ecom_ShipTo_Postal_StateProv'}">
<input type="hidden" name="pt_shipping_postal_code" value="$eform_data{'Ecom_ShipTo_Postal_PostalCode'}">
<input type="hidden" name="pt_shipping_country" value="$eform_data{'Ecom_ShipTo_Postal_CountryCode'}">
ENDOFTEXT

  if ( $PnPSS2_verifytable eq '' ) {
    $PnPSS2_verifytable = 'verifyTable_standard.inc';
  }
  require_supporting_libraries( __FILE__, __LINE__, "$sc_cartverifyplates_dir/$PnPSS2_verifytable" );

  print $sc_verifytable_at_checkout;
}

############################################################################################

sub process_PnPSS2_Order {
  local ( $subtotal, $total_quantity, $total_measured_quantity, $text_of_cart, $html_of_cart, $html_of_cart_header, $weight, $required_fields_filled_in, $product, $quantity, $options );
  local ($stevo_shipping_thing) = q{};
  local ($stevo_shipping_names) = q{};
  local ( $ship_thing_too, $ship_instructions, $xcomments_html );
  local (%orderLoggingHash);
  local ($verification) = q{};
  local (%zip_list);
  local (%zip_names_list);
  $sc_use_secure_header_at_checkout = 'yes';
  $sc_skip_store_header_at_thankyou = 'yes';

  my $temp_admin_email_template = $PnPSS2_admin_email_template;
  if ( $temp_admin_email_template eq '' ) {
    $temp_admin_email_template = 'admin_emailPlate_text_default01.inc';
  }

  my $temp_email_template = $PnPSS2_email_template;
  if ( $temp_email_template eq '' ) {
    $temp_email_template = 'emailPlate_text_default01.inc';
  }

  load_verify_file();

  if ( $cart_id ne $form_data{'pt_account_code_1'} ) {
    $verification .= "\nWARNING: Cart ID does NOT match expected value!!\n\n";
  }

  codehook('process-order-routine-top');

  $orderDate = get_date();

  # print store header
  standard_page_header();
  CheckoutStoreHeader();

  # default data entered at cart order  form logged here, if exists.
  populate_orderlogging_hash();

  $orderLoggingHash{'orderDate'}   = "$orderDate";
  $orderLoggingHash{'GatewayUsed'} = 'PlugnPaySS2';

  if ($sc_use_html_customer_emails =~ /yes/i)  {
    $html_of_cart_header = cart_html_headerinfo();
  }

  open(CART,'<',$sc_cart_path) || file_open_error( "$sc_cart_path", 'display_cart_contents', __FILE__,__LINE__ );
  while (<CART>) {
    $cartData++;
    @cart_fields   = split( /\|/, $_ );
    $quantity      = $cart_fields[0];
    $product_price = $cart_fields[3];
    $product       = $cart_fields[4];
    $weight        = $cart_fields[6];
    $options       = $cart_fields[ $cart{"options"} ];
    $options =~ s/<br>/ /g;
    $text_of_cart         .= cart_textinfo(*cart_fields);
    if ($sc_use_html_customer_emails =~ /yes/i)  {
      $html_of_cart .= cart_html_textinfo(*cart_fields);
    }
    $stevo_shipping_thing .= "|$quantity\*$weight";
    $stevo_shipping_names .= "|$product\($options\)";
    codehook('process-cart-item');
  }
  close(CART);

  $sc_orderlib_use_SBW_for_ship_ins = $sc_use_SBW;

  codehook('orderlib-ship-instructions');

  if ( $sc_orderlib_use_SBW_for_ship_ins =~ /yes/i ) {
    ($ship_thing_too, $ship_instructions) = ship_put_in_boxes($stevo_shipping_thing, $stevo_shipping_names, $sc_verify_Origin_ZIP, $sc_verify_boxes_maPnPSS2_x_wt);
  }

  $orderLoggingHash{'shippingMessages'} = "$ship_instructions";
  $orderLoggingHash{'shippingMessages'} =~ s/\n/<br>/g;
  $orderLoggingHash{'cart_and_order_id'} = "$form_data{'pt_account_code_1'}";
  $orderLoggingHash{'cart_invoiceNumber'}  = "$form_data{'pt_account_code_2'}";

  if ( $sc_verify_shipping ne $form_data{'pt_shipping_amount'} ) {
    $verification .= "\nWARNING: Shipping Cost from gateway does NOT match expected value!!\n\n";
  }

  if ( $form_data{'pt_tax_amount'} ne $sc_verify_tax ) {
    $verification .= 'WARNING: sales taxes from gateway does not match expected sales tax.\n';
  }

  if ( $form_data{'pt_transaction_amount'} ne $sc_verify_grand_total ) {
    $verification .= "WARNING: Grand total from gateway does not match expected grand total.\n";
  }

  $orderLoggingHash{'fullName'}         = "$form_data{'pt_billing_name'}";
  $orderLoggingHash{'firstName'}        = "$form_data{'pt_billing_first_name'}";
  $orderLoggingHash{'lastName'}         = "$form_data{'pt_billing_last_name'}";
  $orderLoggingHash{'orderFromAddress'} = "$form_data{'pt_billing_address_1'}";
  $orderLoggingHash{'orderFromCity'}    = "$form_data{'pt_billing_city'}";
  $orderLoggingHash{'orderFromState'}   = "$form_data{'pt_billing_state'}";
  $orderLoggingHash{'orderFromPostal'}  = "$form_data{'pt_billing_postal_code'}";
  $orderLoggingHash{'orderFromCountry'} = "$form_data{'pt_billing_country'}";
  $orderLoggingHash{'customerPhone'}    = "$form_data{'pt_billing_phone_number'}";
  $orderLoggingHash{'emailAddress'}     = "$form_data{'pt_billing_email_address'}";

  $sc_thankyou_page_header_title_box =~ s/\[\[verify_page_header_text\]\]/$agora_thankyou_page_title_text/g;
  $sc_thankyou_page_header_title_box =~ s/\[\[name\]\]/$orderLoggingHash{'firstName'}/g;
  print $sc_thankyou_page_header_title_box;
  if ( $PnPSS2_show_table ne 'no') {
    display_thanks_cart_table();
  }

  if ( $form_data{'pt_shipping_name'} || $form_data{'pt_shipping_first_name'} ) {
    if ($form_data{'pt_shipping_first_name'}) {
      $orderLoggingHash{'shipToName'} = "$form_data{'xhipping_first_name'} $form_data{'pt_shipping_last_name'}";
    }
    else {
      $orderLoggingHash{'shipToName'} = "$form_data{'pt_shipping_name'}";
    }
  }
  else {
    if ($form_data{'pt_billing_first_name'}) {
      $orderLoggingHash{'shipToName'} = "$form_data{'pt_billing_first_name'} $form_data{'pt_billing_last_name'}";
    }
    else {
      $orderLoggingHash{'shipToName'} = "$form_data{'pt_billing_name'}";
    }
  }

  if ( $form_data{'pt_shipping_address_1'} ) {
    $orderLoggingHash{'shipToAddress'} = "$form_data{'pt_shipping_address_1'}";
  }
  else {
    $orderLoggingHash{'shipToAddress'} = "$form_data{'pt_billing_address_1'}";
  }

  if ( $form_data{'pt_shipping_city'} ) {
    $orderLoggingHash{'shipToCity'} = "$form_data{'pt_shipping_city'}";
  }
  else {
    $orderLoggingHash{'shipToCity'} = "$form_data{'pt_billing_city'}";
  }

  if ( ( $form_data{'pt_shipping_state'} ) && ( $form_data{'pt_shipping_state'} eq $eform_Ecom_ShipTo_Postal_StateProv ) )  {
    $orderLoggingHash{'shipToState'} = "$form_data{'pt_shipping_state'}";
  }
  else {
    $orderLoggingHash{'shipToState'} = "$eform_Ecom_ShipTo_Postal_StateProv";
    $verification .= "WARNING: Ship to State/Province from gateway does not match expected state/province.\n";
  }

  if ( ( $form_data{'pt_shipping_postal_code'} ) && ( $form_data{'pt_shipping_postal_code'} eq $eform_Ecom_ShipTo_Postal_PostalCode ) )   {
    $orderLoggingHash{'shipToPostal'} = "$form_data{'pt_shipping_postal_code'}";
  }
  else {
    $orderLoggingHash{'shipToPostal'} = "$eform_Ecom_ShipTo_Postal_PostalCode";
    $verification .= "WARNING: Ship to zip/postal code from gateway does not match expected zip/postal code.\n";
  }

  if ( $form_data{'pt_shipping_country'} ) {
    $orderLoggingHash{'shipToCountry'} = "$form_data{'pt_shipping_country'}";
  }
  else {
    $orderLoggingHash{'shipToCountry'} = "$eform_Ecom_ShipTo_Postal_CountryCode";
  }

  codehook('process-order-pre-xcomments');

  $orderLoggingHash{'adminMessages'} = "$verification<br><br>$XCOMMENTS_ADMIN";
  $orderLoggingHash{'adminMessages'} .= qq|\nAUTHORIZATION INFORMATION --------------\nFINALSTATUS: $form_data{'pi_response_status'}\nDUPLICATE: $form_data{'pi_duplicate_transaction'}\nREASON CODE: $form_data{'pi_response_code'}\nREASON TEXT: $form_data{'pi_error_message'}\nAUTH CODE: $form_data{'pt_authorization_code'}\nIP ADDRESS: $form_data{'pt_ip_address'}\nTRANS ID: $form_data{'pt_order_id'}\n--------------------------------------------\n|;
  $orderLoggingHash{'xcomments'} = "$XCOMMENTS";

  $PnPSS2_pt_order_classifier .= ' - ' . $form_data{'pt_account_code_1'};

  if ( $sc_send_order_to_email =~ /yes/i ) {
    local $text_of_cart_to_send = replace_email_template_tokens($temp_admin_email_template);
    codehook('admin_mailtosend');
    send_mail(
      $sc_admin_email, $sc_order_email,
      $PnPSS2_pt_order_classifier, $text_of_cart_to_send
    );
  }

  if ( $cartData && $form_data{'pt_billing_email_address'} ) {
    if ($sc_use_html_customer_emails =~ /yes/i)  {
      $sc_email_content_type = 'text/html';
    }
    $xcomments_html = $orderLoggingHash{'pt_customer_comments'};
    $xcomments_html =~ s/\n/<br>/g;
    my $text_of_cart_to_send = replace_email_template_tokens($temp_email_template);
    send_mail(
      $sc_admin_email,        $form_data{'pt_billing_email_address'},
      $messages{'ordcnf_08'}, "$text_of_cart_to_send"
    );
  }

  $orderLoggingHash{'adminMessages'} =~ s/\n/<br>/g;
  $orderLoggingHash{'adminMessages'} =~ s/\t/ /g;
  $orderLoggingHash{'xcomments'}     =~ s/\n/<br>/g;
  $orderLoggingHash{'adminMessages'} =~ s/\t/ /g;

  log_order( $form_data{'pt_account_code_1'}, $form_data{'pt_account_code_2'} );

  $sc_affiliate_order_unique = $form_data{'xlccount_code_1'};
  $sc_affiliate_order_total = format_price( $orderLoggingHash{'affiliateTotal'} );
  $sc_affiliate_image_call =~ s/AMOUNT/$sc_affiliate_order_total/g;
  $sc_affiliate_image_call =~ s/UNIQUE/$sc_affiliate_order_unique/g;

  codehook('process-order-display-thankyou-page');

  if ( $PnPSS2_thankstable eq '' ) {
    $PnPSS2_thankstable = 'thanksTable_basic1.inc';
  }
  require_supporting_libraries( __FILE__, __LINE__,"$sc_thankyouplates_dir/$PnPSS2_thankstable" );

  print $sc_thankstable_after_checkout;
  print qq{<br><br>$sc_affiliate_image_call};

  CheckoutStoreFooter();

  undef(%form_data);

  set_agora('AGORA_ORDER_COMPLETED', 'yes');
  eval("unlink  \"$sc_verify_order_path\";");
  agora_cookie_save();
  empty_cart();
  eval("unlink  \"$sc_cart_path\";");
}

#######################################################################

1;
