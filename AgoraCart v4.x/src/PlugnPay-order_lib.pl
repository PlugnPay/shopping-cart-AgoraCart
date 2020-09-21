#######################################################################
#                    Order Form Definition Variables                  #
#######################################################################

# Module Last Updated: 02/21/02

$versions{'PlugnPay-order_lib.pl'} = "20020222";

$sc_order_response_vars{"PlugnPay"}="FinalStatus";
#$sc_use_secure_header_at_checkout = 'yes';

&add_codehook("printSubmitPage","print_PlugnPay_SubmitPage");
&add_codehook("set_form_required_fields","PlugnPay_fields");
&add_codehook("gateway_response","check_for_PlugnPay_response");
&add_codehook("special_navigation","check_for_PlugnPay_response");

###############################################################################
sub check_for_PlugnPay_response {
  if ($form_data{'FinalStatus'} eq "success") {
    $cart_id = $form_data{'cart_id'};
    &set_sc_cart_path;
    &load_order_lib;
    &codehook("PlugnPay_order");
    &process_PlugnPay_Order;
    &call_exit;
  }
}
###############################################################################
sub PlugnPay_order_form_prep { # load the customer info ...
  if ($sc_PlugnPay_form_prep == 0) {
    if (-f "$sc_verify_order_path"){
      &read_verify_file;
    }
    else {
      &codehook("load_customer_info");
    }
    $sc_PlugnPay_form_prep = 1;
  }
  return "";
}
###############################################################################
sub PlugnPay_fields {

local($myname) = "PlugnPay";

if (!($form_data{'gateway'} eq $myname)) { return; } 

  %sc_order_form_array = (
    'Ecom_BillTo_Postal_Name_First',    'First Name',
    'Ecom_BillTo_Postal_Name_Last',     'Last Name',
    'Ecom_BillTo_Postal_Street_Line1',  'Billing Address Street',
    'Ecom_BillTo_Postal_City',          'Billing Address City',
    'Ecom_BillTo_Postal_StateProv',     'Billing Address State',
    'Ecom_BillTo_PostalCode',           'Billing Address Zip',
    'Ecom_BillTo_Postal_CountryCode',   'Billing Address Country',
    'Ecom_ShipTo_Postal_Street_Line1',  'Shipping Address Street',
    'Ecom_ShipTo_Postal_City',          'Shipping Address City',
    'Ecom_ShipTo_Postal_StateProv',     'Shipping Address State',
    'Ecom_ShipTo_Postal_PostalCode',    'Shipping Address Zip',
    'Ecom_ShipTo_Postal_CountryCode',   'Shipping Address Country',
    'Ecom_BillTo_Telecom_Phone_Number', 'Phone Number',
    'Ecom_BillTo_Online_Email',         'Email',
    'Ecom_Payment_Card_Type',           'Type of Card',
    'Ecom_Payment_Card_Number',         'Card Number',
    'Ecom_Payment_Card_ExpDate_Month',  'Card Expiration Month',
    'Ecom_Payment_Card_ExpDate_Day',    'Card Expiration Day',
    'Ecom_Payment_Card_ExpDate_Year',   'Card Expiration Year'
  );

  @sc_order_form_required_fields = (
    "Ecom_ShipTo_Postal_StateProv",
    "Ecom_ShipTo_Postal_PostalCode"
  );

}
###############################################################################
sub PlugnPay_verification_table {
  local ($rslt) = "";

  $rslt  = "<table border=0 width=100%>\n";
  $rslt .= "  <tr>\n";
  $rslt .= "    <td align=center>State: $form_data{'Ecom_ShipTo_Postal_StateProv'} </td>\n";
  $rslt .= "    <td align=center>Zip: $form_data{'Ecom_ShipTo_Postal_PostalCode'} </td>\n";
  $rslt .= "  </tr>\n";
  $rslt .= "</table>\n";
  return $rslt;
}
###############################################################################
sub pnp_table_setup {

  local (@my_cart_fields,$my_cart_row_number,$result);
  local ($count,$price,$product_id,$quantity,$total_cost,$total_qty)=0;
  local ($name,$cost);

  $pnp_prod_in_cart = '';
  $pnp_cart_table = '';
  $result = '';

  open (CART, "$sc_cart_path") || &file_open_error("$sc_cart_path", "display_cart_contents_in_header", __FILE__, __LINE__);
  while (<CART>) {
    $count++;
    chop;    
    @my_cart_fields = split (/\|/, $_);
    $my_cart_row_number = pop(@my_cart_fields);
    push (@my_cart_fields, $my_cart_row_number);
    $quantity = $my_cart_fields[0];
    $product_id = $my_cart_fields[1];
    $price = $my_cart_fields[$sc_cart_index_of_price_after_options]; 
    $name = $my_cart_fields[$cart{"name"}];
    $name = substr($name,0,35);
    $cost = &format_price($quantity * $price);
    $total_cost = $total_cost + $quantity * $price;
    $total_qty = $total_qty + $quantity;
    $options = $my_cart_fields[$cart{"options"}];
    $options =~ s/<br>/ /g;
    if ($result eq '') {
      $result .= "<TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0 WIDTH=425>\n";
      $result .= "  <TR>\n";
      $result .= "    <TD>Items Ordered:</TD>\n";
      $result .= "  </TR>\n";
      $result .= "  <TR>\n";
      $result .= "    <TD>\n";
      $result .= "      <TABLE CELLPADDING=3 CELLSPACING=0 BORDER=1 WIDTH='100%'>\n";
      $result .= "        <TR>\n";
      $result .= "          <TH>QTY</TH>\n";
      $result .= "          <TH>ID #</TH>\n";
      $result .= "          <TH>Description</TH>\n";
      $result .= "          <TH>Cost</TH>\n";
      $result .= "        </TR>\n";
      $pnp_prod_in_cart .= "  --PRODUCT INFORMATION--\n\n";
    }
    $result .= "        <TR>\n";
    $result .= "          <TD>$quantity</TD>\n";
    $result .= "          <TD>$product_id</TD>\n";
    $result .= "          <TD>$name</TD>\n";
    $result .= "          <TD>$cost</TD>\n";
    $result .= "        </TR>\n";
    $pnp_prod_in_cart .= &cart_textinfo(*my_cart_fields);
  } # End of while (<CART>)
  close (CART);
  if ($result ne '') {
    $result .= "      </TABLE>\n";
    $result .= "    </TD>\n";
    $result .= "  </TR>\n";
    $result .= "</TABLE>\n";
  }
  $pnp_cart_table = $result;
}

###############################################################################
sub print_PlugnPay_SubmitPage {

local($invoice_number, $customer_number);
local($test_mode,$mytable);
local($myname) = "PlugnPay";

if (!($form_data{'gateway'} eq $myname)) { return; } 

if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__, "./admin_files/$myname-user_lib.pl");
}

&codehook("PlugnPay-SubmitPage-top");

$mytable = &PlugnPay_verification_table;

if ($merchant_live_mode =~ /yes/i){
  $test_mode = "";
}
else {
  $test_mode .= "<!-- Prefilled Billing Info -->\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-name VALUE=\"pnptest\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-address1 VALUE=\"123 Test Street\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-address2 VALUE=\"Apt. 1A\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-city VALUE=\"Test City\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-state VALUE=\"NY\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-zip VALUE=\"12345\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-prov VALUE=\"Test\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-country VALUE=\"US\">\n";
  $test_mode .= "<!-- Prefilled Shipping Info -->\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=shipname VALUE=\"pnptest\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=address1 VALUE=\"123 Test Street\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=address2 VALUE=\"Apt. 1A\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=city VALUE=\"Test City\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=state VALUE=\"NY\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=zip VALUE=\"12345\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=province VALUE=\"Test\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=country VALUE=\"US\">\n";
  $test_mode .= "<!-- Prefilled Other Fields -->\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=email VALUE=\"trash\@plugnpay.com\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=phone VALUE=\"555-555-5555\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=fax VALUE=\"666-666-6666\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-type VALUE=\"visa\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-number VALUE=\"4111111111111111\">\n";
}

$invoice_number = $current_verify_inv_no;
$customer_number = $form_data{'cart_id'};
#$customer_number = $cart_id;
$customer_number =~ s/_/./g;

&pnp_table_setup;

&codehook("PlugnPay-SubmitPage-print");

# SHOW PNP FORM FIELDS HERE
print <<ENDOFTEXT;

<FORM METHOD=POST ACTION=\"https://pay1.plugnpay.com/payment/pay.cgi\">
<!-- Required Settings -->
<INPUT TYPE=HIDDEN NAME=publisher-name VALUE=\"$sc_gateway_username\">
<INPUT TYPE=HIDDEN NAME=publisher-email VALUE=\"$sc_gateway_email\">
<INPUT TYPE=HIDDEN NAME=card-allowed VALUE=\"$sc_gateway_card_allowed\">
<INPUT TYPE=HIDDEN NAME=card-amount VALUE=\"$authPrice\">
ENDOFTEXT

print "<!-- Email Settings -->\n";

if ($sc_gateway_cc_mail ne "") {
  print "<INPUT TYPE=HIDDEN NAME=cc-mail VALUE=\"$sc_gateway_cc_mail\">\n";
}

if ($sc_gateway_subject ne "") {
  print "<INPUT TYPE=HIDDEN NAME=subject VALUE=\"$sc_gateway_subject\">\n";
}

if ($sc_gateway_message ne "") {
  print "<INPUT TYPE=HIDDEN NAME=message VALUE=\"$sc_gateway_message\">\n";
}

if ($sc_gateway_subject_email ne "") {
  print "<INPUT TYPE=HIDDEN NAME=subject-email VALUE=\"$sc_gateway_subject_email\">\n";
}

if ($sc_gateway_dontsendmail ne "yes") {
  print "<INPUT TYPE=HIDDEN NAME=dontsendmail VALUE=\"yes\">\n";
}

print "<!-- Misc Settings -->\n";

if ($sc_gateway_avs_level ne "") {
  print "<INPUT TYPE=HIDDEN NAME=app-level VALUE=\"$sc_gateway_avs_level\">\n";
}

if ($zfinal_sales_tax ne "") {
  print "<INPUT TYPE=HIDDEN NAME=tax VALUE=\"$zfinal_sales_tax\">\n";
}

if ($invoice_number ne "") {
  print "<INPUT TYPE=HIDDEN NAME=order-id VALUE=\"$invoice_number\">\n";
}

if ($customer_number ne "") {
  print "<INPUT TYPE=HIDDEN NAME=customer_number VALUE=\"$customer_number\">\n";
}

if ($sc_gateway_comments eq "yes") {
  print "<INPUT TYPE=HIDDEN NAME=comments VALUE=\" \">\n";
}

if ($sc_gateway_calculate_tax eq "yes") {
  print "<INPUT TYPE=HIDDEN NAME=taxrate VALUE=\"$sc_gateway_taxrate\">\n";
  print "<INPUT TYPE=HIDDEN NAME=taxstate VALUE=\"$sc_gateway_taxstate\">\n";
}

if ($sc_gateway_easycart ne "no") {
  print "<INPUT TYPE=HIDDEN NAME=easycart VALUE=\"1\">\n";
}
else {
  print "<INPUT TYPE=HIDDEN NAME=easycart VALUE=\"0\">\n";
}

print "<!-- Shipping Settings -->\n";

if ($sc_gateway_shipinfo ne "no") {
  print "<INPUT TYPE=HIDDEN NAME=shipinfo VALUE=\"1\">\n";
}
else {
  print "<INPUT TYPE=HIDDEN NAME=shipinfo VALUE=\"0\">\n";
}

if ($zfinal_shipping ne "") {
  print "<INPUT TYPE=HIDDEN NAME=shipping VALUE=\"$zfinal_shipping\">\n";
}

if ($sc_gateway_use_shipping_calculator eq "yes") {
  if ($sc_gateway_shipmethod ne "") {
    print "<INPUT TYPE=HIDDEN NAME=shipmethod VALUE=\"$sc_gateway_shipmethod\">\n";
  }

  if ($sc_gateway_merchant_zip ne "") {
    print "<INPUT TYPE=HIDDEN NAME=merchant-zip VALUE=\"$sc_gateway_merchant_zip\">\n";
  }

  if ($sc_gateway_usps_container ne "") {
    print "<INPUT TYPE=HIDDEN NAME=usps-container VALUE=\"$sc_gateway_usps_container\">\n";
  }

  if ($sc_gateway_usps_size ne "") {
    print "<INPUT TYPE=HIDDEN NAME=usps-size VALUE=\"$sc_gateway_usps_size\">\n";
  }

  if ($sc_gateway_ups_rate_chart ne "") {
    print "<INPUT TYPE=HIDDEN NAME=ups-rate-chart VALUE=\"$sc_gateway_ups_rate_chart\">\n";
  }

  if ($sc_gateway_mailtype ne "") {
    print "<INPUT TYPE=HIDDEN NAME=mailtype VALUE=\"$sc_gateway_mailtype\">\n";
  }

  if ($sc_gateway_machinable ne "") {
    print "<INPUT TYPE=HIDDEN NAME=machinable VALUE=\"$sc_gateway_machinable\">\n";
  }

  if ($sc_gateway_rate_chart ne "") {
    print "<INPUT TYPE=HIDDEN NAME=rate-chart VALUE=\"$sc_gateway_rate_chart\">\n";
  }

  if ($sc_gateway_method_allow ne "") {
    print "<INPUT TYPE=HIDDEN NAME=method-allow VALUE=\"$sc_gateway_method_allow\">\n";
  }
}

print "<!-- User Defined Fields -->\n";

if (($sc_gateway_userfield1_name ne "") && ($sc_gateway_userfield1_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield1_name VALUE=\"$sc_gateway_$sc_gateway_userfield1_value\">\n";
}

if (($sc_gateway_userfield2_name ne "") && ($sc_gateway_userfield2_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield2_name VALUE=\"$sc_gateway_$sc_gateway_userfield2_value\">\n";
}

if (($sc_gateway_userfield3_name ne "") && ($sc_gateway_userfield3_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield3_name VALUE=\"$sc_gateway_$sc_gateway_userfield3_value\">\n";
}

if (($sc_gateway_userfield4_name ne "") && ($sc_gateway_userfield4_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield4_name VALUE=\"$sc_gateway_$sc_gateway_userfield4_value\">\n";
}

if (($sc_gateway_userfield5_name ne "") && ($sc_gateway_userfield5_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield5_name VALUE=\"$sc_gateway_$sc_gateway_userfield5_value\">\n";
}

if (($sc_gateway_userfield6_name ne "") && ($sc_gateway_userfield6_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield6_name VALUE=\"$sc_gateway_$sc_gateway_userfield6_value\">\n";
}

if (($sc_gateway_userfield7_name ne "") && ($sc_gateway_userfield7_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield1_name VALUE=\"$sc_gateway_$sc_gateway_userfield1_value\">\n";
}

if (($sc_gateway_userfield8_name ne "") && ($sc_gateway_userfield8_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield8_name VALUE=\"$sc_gateway_$sc_gateway_userfield8_value\">\n";
}

if (($sc_gateway_userfield9_name ne "") && ($sc_gateway_userfield9_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield9_name VALUE=\"$sc_gateway_$sc_gateway_userfield9_value\">\n";
}

if (($sc_gateway_userfield10_name ne "") && ($sc_gateway_userfield10_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield10_name VALUE=\"$sc_gateway_$sc_gateway_userfield10_value\">\n";
}

if (($sc_gateway_userfield11_name ne "") && ($sc_gateway_userfield11_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield11_name VALUE=\"$sc_gateway_$sc_gateway_userfield11_value\">\n";
}

if (($sc_gateway_userfield12_name ne "") && ($sc_gateway_userfield12_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield12_name VALUE=\"$sc_gateway_$sc_gateway_userfield12_value\">\n";
}

print "<!-- URL Link Settings -->\n";

if ($sc_gateway_success_link eq "") {
  print "<INPUT TYPE=HIDDEN NAME=success-link VALUE=\"$sc_store_url\">\n";
}
else {
  print "<INPUT TYPE=HIDDEN NAME=success-link VALUE=\"$sc_gateway_success_link\">\n";
}

if ($sc_gateway_badcard_link ne "") {
  print "<INPUT TYPE=HIDDEN NAME=badcard-link VALUE=\"$sc_gateway_badcard_link\">\n";
}

if ($sc_gateway_problem_link ne "") {
  print "<INPUT TYPE=HIDDEN NAME=problem-link VALUE=\"$sc_gateway_problem_link\">\n";
}

print "<!-- Itemized Product Info --> \n";

open (CART, "$sc_cart_path") || &file_open_error("$sc_cart_path", "display_cart_contents_in_header", __FILE__, __LINE__);
while (<CART>) {
  $count++;
  chop;    
  @my_cart_fields = split (/\|/, $_);
  print "<INPUT TYPE=HIDDEN NAME=\"item$count\" VALUE=\"$my_cart_fields[1]\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"quantity$count\" VALUE=\"$my_cart_fields[0]\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"description$count\" VALUE=\"$my_cart_fields[4] $options\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"cost$count\" VALUE=\"$my_cart_fields[13]\">\n";
  if ($sc_gateway_send_weight =~ /yes/i) {
    print "<INPUT TYPE=HIDDEN NAME=\"weight$count\" VALUE=\"$my_cart_fields[6]\">\n";
  }
}
close (CART);

print "$test_mode";

print "<!-- Agora Cart Name/Value Pairs--> \n";

foreach $key (sort keys %form_data) {
  print "<INPUT TYPE=HIDDEN NAME=\"$key\" VALUE=\"$form_data{$key}\"> \n";
}

print "<!-- Payment Method Options --> \n";

if ($sc_gateway_paymethod ne "") {
  @pnp_payment_options = split(/\|/, $sc_gateway_paymethod);
  print "<p>Please select your method of payment: <SELECT NAME=PAYMETHOD>\n";
  for ($aaa = 0; $aaa <= $#pnp_payment_options; $aaa++) {
    if ($pnp_payment_options[$aaa] eq "onlinecheck") {
      print "<OPTION VALUE=\"onlinecheck\">Check</OPTION>\n";
    }
    elsif ($pnp_payment_options[$aaa] eq "credit") {
      print "<OPTION VALUE=\"credit\">Credit Card</OPTION>\n";
    }
    else {
      print "<OPTION VALUE=\"$pnp_payment_options[$aaa]\">$pnp_payment_options[$aaa]</OPTION>\n";
    }
  }
  print "</SELECT>\n";
}

print "<p>* <font color=\"\#ff0000\"><u>Note</u></font>: Sales Tax & Shipping fees will be recalculated at checkout and maybe differ then the fees quoted above.<p> \n";

print <<ENDOFTEXT;

<TABLE WIDTH="500" BGCOLOR="#C0FFFF" CELLPADDING="0" CELLSPACING="0">
  <TR>
    <TD><TABLE WIDTH="500" BGCOLOR="#000080" CELLPADDING="0" CELLSPACING="0">
      <TR>
        <TD BGCOLOR="#C0FFFF"><FONT FACE="ARIAL" SIZE="2" COLOR="#000000">$messages{'ordcnf_06'}</FONT></TD>
        <TD BGCOLOR="#C0FFFF">
      </TR>
      <TR>
        <TD BGCOLOR="#C0FFFF"><FONT FACE="ARIAL" SIZE="2" COLOR="#000000">$mytable</TD>
      </TR>

      <TR>
        <TD BGCOLOR="#C0FFFF"><FONT FACE="ARIAL" SIZE="2" COLOR="#000000"><b>Please verify the following information. When you are confident that it is correct, click the 'Secure Orderform' button to enter your payment information, or <a href="$sc_stepone_order_script_url\?order_form_button.x=1">click here</a> to make corrections:</b></FONT></TD>
      </TR>

      <TR>
        <TD BGCOLOR="#C0FFFF">&nbsp;</TD>
      </TR>
      <TR>
        <TD ALIGN="CENTER" BGCOLOR="#C0FFFF"><INPUT TYPE=SUBMIT VALUE="Secure Orderform"></TD>
      </TR>
      <TR>
        <TD BGCOLOR="#C0FFFF">&nbsp;</TD>
      </TR>
    </TABLE></TD>
  </TR>
</TABLE>

</FORM>
</CENTER>

ENDOFTEXT

}
############################################################################################
sub process_PlugnPay_Order {

local($subtotal, $total_quantity,
      $total_measured_quantity,
      $text_of_cart, $weight,
      $required_fields_filled_in,
      $product, $quantity, $options);
local($stevo_shipping_thing) = "";
local($stevo_shipping_names) = "";
local($mytext) = "";
local($ship_thing_too,$ship_instructions);


# Note: The below comments & code is left over from the script rewrite...  Don't know if it's needed, so I left it in.

## Need to process this info someday ... 
&load_verify_file;
##
## Now verify the order total and the shipping cost
##if ((!($sc_verify_shipping == $form_data{'shipping'})) || (!($sc_verify_grand_total == $form_data{'card-amount'}))) {
##  $mytext =  "This order failed automatic verification, and has been \n";
##  $mytext .= "marked for manual verification.  The reason is:\n";
##  if (!($sc_verify_shipping == $form_data{'shipping'})) {
##    $mytext .= "Shipping amount: $form_data{'shipping'}  " . " (expected $sc_verify_shipping).\n";
##  }
##  if (!($sc_verify_grand_total == $form_data{'card-amount'})) {
##    $mytext .= "Order Total: $form_data{'card-amount'}  " . " (expected $sc_verify_grand_total).\n";
##  }
##}

# First, we output the header of the processing of the order

$orderDate = &get_date;

print "<HTML>\n";
print "<HEAD>\n";
print "<TITLE>$messages{'ordcnf_08'}</TITLE>\n";
print "$sc_standard_head_info\n";
print "</HEAD>\n";
print "<BODY $sc_standard_body_info>\n";

&SecureStoreHeader; # Don't Use standard header

if ($form_data{'FinalStatus'} ne "success") { # there is a problem ...
  if ($form_data{'FinalStatus'} eq "badcard") { # declined ... dump cart ??
    &empty_cart;
  }
  print "<CENTER>\n";
  print "<TABLE WIDTH=500>\n";
  print "  <TR>\n";
  print "    <TD WIDTH=500><FONT FACE=ARIAL>\n";
  print "      <P>&nbsp;</P>\n";
  print "      $messages{'ordcnf_05'}<br>\n";
  print "      $form_data{'MErrMsg'}<br>\n";
  print "      <P>&nbsp;</P>\n";
  print "      $messages{'ordcnf_02'}<br>\n";
  print "      </FONT>\n";
  print "    </TD>\n";
  print "  </TR>\n";
  print "</TABLE>\n";
  print "<CENTER>\n";

  &SecureStoreFooter;

  print "  </BODY>\n";
  print "  </HTML>\n";

  &call_exit;
}

# All went well at PlugnPay, proceed with processing

print $mytext;

$text_of_cart .= "$mytext";
$text_of_cart .= "Order Date:    $orderDate\n";
$text_of_cart .= "Gateway:       PlugnPay\n\n";

$text_of_cart .= "  --PRODUCT INFORMATION--\n\n";

open (CART, "$sc_cart_path") ||
&file_open_error("$sc_cart_path", "display_cart_contents", __FILE__, __LINE__);

while (<CART>) {
  $cartData++;
  @cart_fields = split (/\|/, $_);
  $quantity = $cart_fields[0];
  $product_price = $cart_fields[3];
  $product = $cart_fields[4];
  $weight = $cart_fields[6];
  $options = $cart_fields[$cart{"options"}];
  $options =~ s/<br>/ /g;
  $text_of_cart .= &cart_textinfo(*cart_fields);
  $stevo_shipping_thing .="|$quantity\*$weight";
  $stevo_shipping_names .="|$product\($options\)";
  &codehook("process-cart-item");
}

close(CART);

$sc_orderlib_use_SBW_for_ship_ins = $sc_use_SBW;
&codehook("orderlib-ship-instructions");

if ($sc_orderlib_use_SBW_for_ship_ins =~ /yes/i) {
  ($ship_thing_too,$ship_instructions) = 
   &ship_put_in_boxes($stevo_shipping_thing,$stevo_shipping_names,
   $sc_verify_Origin_ZIP,$sc_verify_boxes_max_wt); 
}

$text_of_confirm_email .= $messages{'ordcnf_07'};

$text_of_confirm_email .= $text_of_cart;
$text_of_confirm_email .= "\n";

$text_of_cart .= "  --ORDER INFORMATION--\n\n";

$text_of_cart .= "CUSTID:        $form_data{'customer_id'}\n";
$text_of_confirm_email .= "CUSTID:        $form_data{'customer_id'}\n";

$text_of_cart .= "INVOICE:       $form_data{'order-id'}\n";
$text_of_confirm_email .= "INVOICE:       $form_data{'order-id'}\n";

if ($form_data{'shipping'}) {
  $text_of_cart .= "SHIPPING:      $form_data{'shipping'}\n";
  $text_of_confirm_email .= "SHIPPING:      $form_data{'shipping'}\n";

  if ($sc_use_SBW =~ /yes/i) {
    $text_of_confirm_email .= "SHIP VIA:      $form_data{'HW2SHIP'}\n";
  }
}

if ($form_data{'discount'}) {
  $text_of_cart .= "DISCOUNT:      $form_data{'discount'}\n";
  $text_of_confirm_email .= "DISCOUNT:      $form_data{'discount'}\n";
}

if ($form_data{'tax'}) {
  $text_of_cart .= "TOT SALES TAX: $form_data{'tax'}\n";
  $text_of_confirm_email .= "TOT SALES TAX: $form_data{'tax'}\n";
}

if ($sc_verify_tax > 0) {
  $temp = substr(substr("SALES TAX",0,13).":               ",0,15);
  $text_of_cart .= "$temp$sc_verify_tax\n";
  $text_of_confirm_email .= "$temp$sc_verify_tax\n";
}

if ($sc_verify_etax1 > 0) {
  $temp = substr(substr($sc_extra_tax1_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$sc_verify_etax1\n";
  $text_of_confirm_email .= "$temp$sc_verify_etax1\n";
}

if ($sc_verify_etax2 > 0) {
  $temp = substr(substr($sc_extra_tax2_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$sc_verify_etax2\n";
  $text_of_confirm_email .= "$temp$sc_verify_etax2\n";
}

if ($sc_verify_etax3 > 0) {
  $temp = substr(substr($sc_extra_tax3_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$sc_verify_etax3\n";
  $text_of_confirm_email .= "$temp$sc_verify_etax3\n";
}

$text_of_cart .= "TOTAL:         $form_data{'card-amount'}\n";
$text_of_confirm_email .= "TOTAL:         $form_data{'card-amount'}\n";

$text_of_cart .= "METHOD:        $form_data{'paymethod'}\n";
$text_of_cart .= "TYPE:          $form_data{'card_type'}\n";

$text_of_cart .= "RESP CODE:     $form_data{'success'}\n";
$text_of_cart .= "AUTH CODE:     $form_data{'auth-code'}\n";
$text_of_cart .= "TRANS ID:      $form_data{'orderID'}\n\n";

$text_of_cart .= "BILLING INFORMATION --------------\n\n";
$text_of_cart .= "NAME:          $form_data{'card-name'}\n";
$text_of_cart .= "COMPANY:       $form_data{'card-company'}\n";
$text_of_cart .= "ADDRESS:       $form_data{'card-address1'}\n";
$text_of_cart .= "CITY:          $form_data{'card-city'}\n";
$text_of_cart .= "STATE:         $form_data{'card-state'}\n";
$text_of_cart .= "ZIP:           $form_data{'card-zip'}\n";
$text_of_cart .= "COUNTRY:       $form_data{'card-country'}\n";
$text_of_cart .= "PHONE:         $form_data{'phone'}\n";
$text_of_cart .= "FAX:           $form_data{'fax'}\n";
$text_of_cart .= "EMAIL:         $form_data{'email'}\n\n";
$text_of_cart .= "SHIPPING INFORMATION --------------\n\n";
$text_of_cart .= "SHIP VIA:      $form_data{'Ecom_ShipTo_Method'}\n";
$text_of_cart .= "NAME:          $form_data{'shipname'}\n";
$text_of_cart .= "COMPANY:       $form_data{'company'}\n";
$text_of_cart .= "ADDRESS:       $form_data{'address1'}\n";
$text_of_cart .= "CITY:          $form_data{'city'}\n";
$text_of_cart .= "STATE:         $form_data{'state'}\n";
$text_of_cart .= "ZIP:           $form_data{'zip'}\n";
$text_of_cart .= "COUNTRY:       $form_data{'country'}\n\n";

if ($ship_instructions ne "") {
  $text_of_cart .= "Shipping Instructions: \n";
  $text_of_cart .= "$ship_instructions\n\n";
}

$text_of_cart .= $XCOMMENTS_ADMIN;
$text_of_confirm_email .= $XCOMMENTS;

# 'Init' the emails ...
$text_of_cart = &init_shop_keep_email . $text_of_cart;
$text_of_confirm_email = &init_customer_email . $text_of_confirm_email;

# and add the rest ...
$text_of_admin_email .= &addto_shop_keep_email;
$text_of_confirm_email .= &addto_customer_email;

if ($sc_use_pgp =~ /yes/i) {
  &require_supporting_libraries(__FILE__, __LINE__, "$sc_pgp_lib_path");
  $text_of_cart = &make_pgp_file($text_of_cart, "$sc_pgp_temp_file_path/$$.pgp");
  $text_of_cart = "\n" . $text_of_cart . "\n";
}

if ($sc_send_order_to_email =~ /yes/i) {
  &send_mail($sc_admin_email, $sc_order_email, "Agora.cgi Order",$text_of_cart);
}

&log_order($text_of_cart,$form_data{'order-id'},$form_data{'cart_id'});

if (($cartData) && ($form_data{'email'} ne "")) {
  &send_mail($sc_admin_email, $form_data{'email'}, $messages{'ordcnf_08'}, "$text_of_confirm_email");
}
  
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=500>
  <TR>
    <TD WIDTH=500>
      <FONT FACE=ARIAL>
      $messages{'ordcnf_09'}

      <pre>$text_of_cart</pre>
      $messages{'ordcnf_02'}
      </FONT>
    </TD>
  </TR>
</TABLE>
<CENTER>

ENDOFTEXT

# This empties the cart after the order is successful
&empty_cart;

# and the footer is printed

&StoreFooter;

print qq!
</BODY>
</HTML>
!;

} # End of process_order_form

#################################################################

1; # Library
