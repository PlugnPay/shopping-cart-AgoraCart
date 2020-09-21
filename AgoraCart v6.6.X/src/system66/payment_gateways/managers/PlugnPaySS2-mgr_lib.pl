$versions{'PlugnPaySS2-mgr_lib.pl'} = '06.6.00.0000';
#
# For the Credit Card Processing Gateway PlugnPay
# SIM version
# Requires AgoraCart version 06.6.00.000 or above.
#
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
add_codehook( 'gateway_admin_screen',  'PnPSS2_mgr_check' );
add_codehook( 'gateway_admin_settings', 'PnPSS2_settings' );
$mc_gateways .= "|PlugnPaySS2::PlugnPay SSv2";
$tstamptemp = time;
##############################################################################
sub PnPSS2_settings {
    if ( $sc_gateway_name eq 'PlugnPaySS2' ) {

        $PnPSS2_verify_message = my_escape( $in{'PnPSS2_verify_message'} );
        $PnPSS2_tos_display_address = my_escape( $in{'PnPSS2_tos_display_address'} );
        $PnPSS2_top_message = my_escape( $in{'PnPSS2_top_message'} );
        $PnPSS2_special_message = my_escape( $in{'PnPSS2_special_message'} );

        open( GW,'>',"$gateway_settings" ) || my_die("Can't Open $gateway_settings");
        print( GW "\$PnPSS2_gateway_account = '$in{'PnPSS2_gateway_account'}';\n" );
        print( GW "\$PnPSS2_pt_order_classifier = '$in{'PnPSS2_pt_order_classifier'}';\n" );
        print( GW "\$PnPSS2_verify_message = \"$PnPSS2_verify_message\";\n" );
        print( GW "\$PnPSS2_display_checkout_tos = \"$in{'PnPSS2_display_checkout_tos'}\";\n" );
        print( GW "\$PnPSS2_tos_display_address = qq|$PnPSS2_tos_display_address|;\n" );
        print( GW "\$PnPSS2_pb_post_auth = '$in{'PnPSS2_pb_post_auth'}';\n" );
        print( GW "\$PnPSS2_email_template = \"$in{'PnPSS2_email_template'}\";\n" );
        print( GW "\$PnPSS2_admin_email_template = \"$in{'PnPSS2_admin_email_template'}\";\n" );
        print( GW "\$PnPSS2_verifytable = \"$in{'PnPSS2_verifytable'}\";\n" );
        print( GW "\$PnPSS2_thankstable = \"$in{'PnPSS2_thankstable'}\";\n" );
        print( GW "\$PnPSS2_top_message = \"$PnPSS2_top_message\";\n" );
        print( GW "\$PnPSS2_special_message = \"$PnPSS2_special_message\";\n" );
        print( GW "\$PnPSS2_show_table = \"$in{'show_table'}\";\n" );

        print( GW "#\n1\;\n" );
        close(GW);

    }
}
##############################################################################
sub PnPSS2_mgr_check {
    if ( $sc_gateway_name eq 'PlugnPaySS2' ) {
        print_PnPSS2_mgr_form();
        call_exit();
    }
}
##############################################################################
sub print_PnPSS2_mgr_form {

    print &$manager_page_header( 'PlugnPay SSv2 Gateway', '', '', '', '' );

    $mc_email_admin_plates = read_templatedirs($sc_emailPlates_dir, 'admin_emailPlate');
    $mc_email_plates = read_templatedirs($sc_emailPlates_dir, 'emailPlate');
    $mc_verifytable_plates = read_templatedirs($sc_cartverifyplates_dir, 'verifyTable');
    $mc_thanktable_plates = read_templatedirs($sc_thankyouplates_dir, 'thanksTable');

    print <<ENDOFTEXT;
<h1 class='mgr-page-title'>PlugnPay SSv2</h1>
<p><br></p>

<p class="well">$msg<br><br><b>How this solution works:</b> This is solution is a legacy payment method that is still supported by PlugnPay.com. The customer fills out a secure form in your store's checkout, then submits to a verify page where they double check their shipping information, and then they are sent to a hosted form at PlugnPay.com where they enter their payment details and make payment. Upon completion, they are sent back to your store where a confirmation is emailed tothe customer and a thank you page displayed.</p>
<p><br></p>

ENDOFTEXT

if ( $in{'system_edit_success'} ) {
    $page_output .= qq|
<div class="row col-xs-12 col-sm-12 col-md-12 col-lg-12 hidden-xs">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 bg-success">
<h4 class="text-primary mgr-center">PlugnPay SSv2 settings have been successfully updated</h4>
</div>
</div>
<p><br><br><br><br><br></p>
|;
}

    print <<ENDOFTEXT;

<form action="manager.cgi" method="post"><input type="hidden" name="mgr_seshun" value="$in{'mgr_seshun'}">

<p><b>Gateway Account:</b><input name="PnPSS2_pt_gateway_account" type="text" class="form-control" maxlength="50" value="$PnPSS2_pt_gateway_account" required></p>
<p><hr></p>

<p><b>Order Classifier:</b><input name="PnPSS2_pt_order_classifier" type="text" class="form-control" maxlength="50" value="$PnPSS2_pt_order_classifier" required></p>
<p><hr></p>

<p><hr></p>

<p><b>PostAuth Transaction: &nbsp; <a data-toggle="collapse" href="#plugnpayPostAuth" aria-expanded="false" aria-controls="plugnpayPostAuth"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><select name="PnPSS2_pb_post_auth">
<option selected>$PnPSS2_pb_post_auth</option>
<option>yes</option>
<option>no</option>
</select></p>
<div class="collapse" id="plugnpayTransType">
    <div class="well">
        <p><b>yes</b> Is the default and will authorize and capture the sale/order/funds.</p>
        <p><b>no</b> authorizes the funds only. To capture &amp; complete the sales, you must visit the merchant control panel at PlugnPay.com to perform such processes.</p>
    </div>
</div>

<p><hr></p>
<p><br></p>

<h3 class='mgr-page-title'>Customize Cart Form Msgs, Receipts, &amp; Emails</h3>
<p><br></p>

<p><b>Order Form - Top Message: &nbsp; <a data-toggle="collapse" href="#plugnpayFormTopMess" aria-expanded="false" aria-controls="plugnpayFormTopMess"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><textarea name="PnPSS2_top_message" class="form-control" maxlength="300" rows=8 wrap="on">$PnPSS2_top_message</textarea></p>
<div class="collapse" id="plugnpayFormTopMess">
    <div class="well">
        <p>Allows you to place a message above the Payment Information area and just below the cart total boxes.</p>
        <p>HTML formatting (for text color, font, spacing, etc) is accepted.</p>
        <p>Leave blank if not needed.</p>
    </div>
</div>

<p><hr></p>

<p><b>Order Form - Special Instructions Message: &nbsp; <a data-toggle="collapse" href="#plugnpayFormSpecMess" aria-expanded="false" aria-controls="plugnpayFormSpecMess"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><textarea name="PnPSS2_special_message" class="form-control" maxlength="300" rows=8 wrap="on">$PnPSS2_special_message</textarea></p>
<div class="collapse" id="plugnpayFormSpecMess">
    <div class="well">
        <p>Allows you to place a message above the discount code and/or comments box towards the bottom of the Customer Information area in a default order form.</p>
        <p>HTML formatting (for text color, font, spacing, etc) is accepted.</p>
        <p>Leave blank if not needed.</p>
    </div>
</div>

<p><hr></p>

<p><b>Verify Page - Special Instructions Message: &nbsp; <a data-toggle="collapse" href="#plugnpayVerifyTopMess" aria-expanded="false" aria-controls="plugnpayVerifyTopMess"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><textarea name="PnPSS2_verify_message" class="form-control" maxlength="300" rows=8 wrap="on">$PnPSS2_verify_message</textarea></p>
<div class="collapse" id="plugnpayVerifyTopMess">
    <div class="well">
        <p>Top message for confirmation page, the page just before going to the hosted page at the gateway. This allows you to place a message above the Payment Information area and just below the cart total boxes.</p>
        <p>HTML formatting (for text color, font, spacing, etc) is accepted.</p>
        <p>Leave blank if not needed.</p>
    </div>
</div>

<p><hr></p>

<p><b>Display ToS &amp; Refund Policy checkbox? &nbsp; <a data-toggle="collapse" href="#plugnpayDisplayTOS" aria-expanded="false" aria-controls="plugnpayDisplayTOS"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><select name="PnPSS2_display_checkout_tos" required>
<option>$PnPSS2_display_checkout_tos</option>
<option>yes</option>
<option>no</option>
</select></p>
<div class="collapse" id="plugnpayDisplayTOS">
    <div class="well">
        <p><b>yes</b> displays <b>Terms of Service and Refund Policy</b> checkbox, and the field is set as <i>required</i> in order for customer to proceed with the additional checkout steps.</p>
        <p><b>no</b> nothing is displayed.</p>
        <p><b>Best Practice:</b> set to <i>YES</i>. Some countries and/or payment processors require customers to be notified of the return and shipping policies, and this is a good place to remind them to read and agree your store/site policies.
    </div>
</div>

<p><br></p>

<p><b>Business address &amp; contact information for your business: &nbsp; <a data-toggle="collapse" href="#plugnpayTOSaddress" aria-expanded="false" aria-controls="plugnpayTOSaddress"><i class="fa fa-info-circle"></i></a></b><span style="padding-left: 25px;"></span><textarea name="PnPSS2_tos_display_address" type="text" class="form-control" required maxlength="400" rows=5 wrap="on">$PnPSS2_tos_display_address</textarea></p>
<div class="collapse" id="plugnpayTOSaddress">
  <div class="well">
    <p>Displays the required business address and contact infomration if the <b>Display TOS</b> option is enabled above.</p>
    <p>Should be legal address for the business location for full disclosure and other privacy requirements mandated by credit card companies as well as government enitities that require such notices.</p>
    <p>HTML formatting (for text color, font, spacing, etc) is accepted.</p>
  </div>
</div>

<p><hr></p>

<p><b>Select Email Template for Emails Sent to Customers: &nbsp; <a data-toggle="collapse" href="#plugnpayEmailTemp" aria-expanded="false" aria-controls="plugnpayEmailTemp"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><select name="PnPSS2_email_template" required>
<option>$PnPSS2_email_template</option>
$mc_email_plates
</select></p>
<div class="collapse" id="plugnpayEmailTemp">
    <div class="well">
        <p>This is the template used to generate the email confirmations sent to your customers.</p>
    </div>
</div>

<p><hr></p>

<p><b>Select Email Template for Emails Sent to Site Admin: &nbsp; <a data-toggle="collapse" href="#plugnpayAdminEmailTemp" aria-expanded="false" aria-controls="plugnpayAdminEmailTemp"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><select name="PnPSS2_admin_email_template" required>
<option>$PnPSS2_admin_email_template</option>
$mc_email_admin_plates
</select></p>
<div class="collapse" id="plugnpayAdminEmailTemp">
    <div class="well">
        <p>This is the template used to generate the email confirmations sent to you.</p>
    </div>
</div>

<p><hr></p>

<p><b>Select the Verify Table Template for the Checkout Verify Page: &nbsp; <a data-toggle="collapse" href="#plugnpayVerifyCheckoutTemp" aria-expanded="false" aria-controls="plugnpayVerifyCheckoutTemp"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><select name="PnPSS2_verifytable" required>
<option>$PnPSS2_verifytable</option>
$mc_verifytable_plates
</select></p>
<div class="collapse" id="plugnpayVerifyCheckoutTemp">
    <div class="well">
        <p>This is the template used to generate the verify page that the customer uses to verify their order information.</p>
        <p>It is the page displayed immediately before going to the the hosted payment page at PlugnPay.com</p>
    </div>
</div>

<p><hr></p>

<p><b>Select the Thankyou Table Template for the Successful Payment Return Page: &nbsp; <a data-toggle="collapse" href="#plugnpayThanksTemp" aria-expanded="false" aria-controls="plugnpayThanksTemp"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><select name="PnPSS2_thankstable" required>
<option>$PnPSS2_thankstable</option>
$mc_thanktable_plates
</select></p>
<div class="collapse" id="plugnpayThanksTemp">
    <div class="well">
        <p>This is the template used to generate the thankyou page that the customer lands on at your store after completing their payment at the hosted form at PlugnPay.com.</p>
    </div>
</div>

<p><hr></p>

<p><b>Show cart contents table on browser receipt after order completion? &nbsp; <a data-toggle="collapse" href="#plugnpayShowCartTable" aria-expanded="false" aria-controls="plugnpayShowCartTable"><i class="fa fa-info-circle"></i></a></b> <span style="padding-left: 20px;"></span><select name="show_table" required>
<option>$PnPSS2_show_table</option>
<option>yes</option>
<option>no</option>
</select></p>
<div class="collapse" id="plugnpayShowCartTable">
    <div class="well">
        <p>If you wish the customer to see a cart contents tble showing what they ordered on th thankyou page, after the payment has been completed, then set to YES.</p>
    </div>
</div>

<p><hr></p>
<p><br></p>

<p><br></p>

<input type="hidden" name="system_edit_success" value="yes">
<input name="GatewaySettings" type="hidden" value="Submit">
<input type="hidden" name="gateway" value="PlugnPaySS2">
<button class="btn btn-primary btn-lg mgr-center" style="display: block;">Submit PlugnPay SSv2 Settings Updates</button>
<p><br><br><br></p>
</form>

ENDOFTEXT
    print &$manager_page_footer;
}
##############################################################################
1;
