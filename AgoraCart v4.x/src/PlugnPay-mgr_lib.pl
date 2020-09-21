#
# For the Credit Card Processing Gateway - Plug 'n Pay Technologies, Inc.
#
# Copyright 2002 Plug 'n Pay Technologies, Inc.  All Rights Reserved.
# Last Updated: 02/13/02

# Notes:
# -- Includes Enhanced Color Selections

$versions{'PlugnPay-mgr_lib.pl'} = "20020222";
&add_codehook("gateway_admin_screen","PlugnPay_mgr_check");
&add_codehook("gateway_admin_settings","PlugnPay_settings");
$mc_gateways .= "|PlugnPay";
##############################################################################
sub PlugnPay_settings {
  if ($sc_gateway_name eq "PlugnPay") {
    open (GW, "> $gateway_settings") || &my_die("Can't Open $gateway_settings");

    # main settings
    print (GW "\$sc_gateway_username = '$in{'sc_gateway_username'}';\n");
    print (GW "\$sc_gateway_card_allowed = '$in{'sc_gateway_card_allowed'}';\n");
    print (GW "\$sc_gateway_paymethod = '$in{'sc_gateway_paymethod'}';\n");

    # misc settings
    print (GW "\$sc_gateway_avs_level = '$in{'sc_gateway_avs_level'}';\n");
    print (GW "\$sc_gateway_comments = '$in{'sc_gateway_comments'}';\n");
    print (GW "\$sc_gateway_easycart = '$in{'sc_gateway_easycart'}';\n");
    print (GW "\$sc_gateway_shipinfo = '$in{'sc_gateway_shipinfo'}';\n");
    print (GW "\$sc_gateway_send_weight = '$in{'sc_gateway_send_weight'}';\n");

    # email settings
    print (GW "\$sc_gateway_email = '$in{'sc_gateway_email'}';\n");
    print (GW "\$sc_gateway_cc_mail = '$in{'sc_gateway_cc_mail'}';\n");
    print (GW "\$sc_gateway_subject = '$in{'sc_gateway_subject'}';\n");
    print (GW "\$sc_gateway_message = '$in{'sc_gateway_message'}';\n");
    print (GW "\$sc_gateway_subject_email = '$in{'sc_gateway_subject_email'}';\n");
    print (GW "\$sc_gateway_dontsendmail = '$in{'sc_gateway_dontsendmail'}';\n");

    # tax settings
    print (GW "\$sc_gateway_calculate_tax = '$in{'sc_gateway_calculate_tax'}';\n");
    print (GW "\$sc_gateway_taxrate = '$in{'sc_gateway_taxrate'}';\n");
    print (GW "\$sc_gateway_taxstate = '$in{'sc_gateway_taxstate'}';\n");

    # link settings
    print (GW "\$sc_gateway_success_link = '$in{'sc_gateway_success_link'}';\n");
    print (GW "\$sc_gateway_badcard_link = '$in{'sc_gateway_badcard_link'}';\n");
    print (GW "\$sc_gateway_problem_link = '$in{'sc_gateway_problem_link'}';\n");

    # shipping calculator settings
    print (GW "\$sc_gateway_use_shipping_calculator = '$in{'sc_gateway_use_shipping_calculator'}';\n");
    print (GW "\$sc_gateway_shipmethod = '$in{'sc_gateway_shipmethod'}';\n");
    print (GW "\$sc_gateway_merchant_zip = '$in{'sc_gateway_merchant_zip'}';\n");
    print (GW "\$sc_gateway_usps_container = '$in{'sc_gateway_usps_container'}';\n");
    print (GW "\$sc_gateway_usps_size = '$in{'sc_gateway_usps_size'}';\n");
    print (GW "\$sc_gateway_ups_rate_chart = '$in{'sc_gateway_ups_rate_chart'}';\n");
    print (GW "\$sc_gateway_mailtype = '$in{'sc_gateway_mailtype'}';\n");
    print (GW "\$sc_gateway_machinable = '$in{'sc_gateway_machinable'}';\n");
    print (GW "\$sc_gateway_rate_chart = '$in{'sc_gateway_rate_chart'}';\n");
    print (GW "\$sc_gateway_method_allow = '$in{'sc_gateway_method_allow'}';\n");

    # user defined field names/values
    print (GW "\$sc_gateway_userfield1_name = '$in{'sc_gateway_userfield1_name'}';\n");
    print (GW "\$sc_gateway_userfield1_value = '$in{'sc_gateway_userfield1_value'}';\n");
    print (GW "\$sc_gateway_userfield2_name = '$in{'sc_gateway_userfield2_name'}';\n");
    print (GW "\$sc_gateway_userfield2_value = '$in{'sc_gateway_userfield2_value'}';\n");
    print (GW "\$sc_gateway_userfield3_name = '$in{'sc_gateway_userfield3_name'}';\n");
    print (GW "\$sc_gateway_userfield3_value = '$in{'sc_gateway_userfield3_value'}';\n");
    print (GW "\$sc_gateway_userfield4_name = '$in{'sc_gateway_userfield4_name'}';\n");
    print (GW "\$sc_gateway_userfield4_value = '$in{'sc_gateway_userfield4_value'}';\n");
    print (GW "\$sc_gateway_userfield5_name = '$in{'sc_gateway_userfield5_name'}';\n");
    print (GW "\$sc_gateway_userfield5_value = '$in{'sc_gateway_userfield5_value'}';\n");
    print (GW "\$sc_gateway_userfield6_name = '$in{'sc_gateway_userfield6_name'}';\n");
    print (GW "\$sc_gateway_userfield6_value = '$in{'sc_gateway_userfield6_value'}';\n");
    print (GW "\$sc_gateway_userfield7_name = '$in{'sc_gateway_userfield7_name'}';\n");
    print (GW "\$sc_gateway_userfield7_value = '$in{'sc_gateway_userfield7_value'}';\n");
    print (GW "\$sc_gateway_userfield8_name = '$in{'sc_gateway_userfield8_name'}';\n");
    print (GW "\$sc_gateway_userfield8_value = '$in{'sc_gateway_userfield8_value'}';\n");
    print (GW "\$sc_gateway_userfield9_name = '$in{'sc_gateway_userfield9_name'}';\n");
    print (GW "\$sc_gateway_userfield9_value = '$in{'sc_gateway_userfield9_value'}';\n");
    print (GW "\$sc_gateway_userfield10_name = '$in{'sc_gateway_userfield10_name'}';\n");
    print (GW "\$sc_gateway_userfield10_value = '$in{'sc_gateway_userfield10_value'}';\n");
    print (GW "\$sc_gateway_userfield11_name = '$in{'sc_gateway_userfield11_name'}';\n");
    print (GW "\$sc_gateway_userfield11_value = '$in{'sc_gateway_userfield11_value'}';\n");
    print (GW "\$sc_gateway_userfield12_name = '$in{'sc_gateway_userfield12_name'}';\n");
    print (GW "\$sc_gateway_userfield12_value = '$in{'sc_gateway_userfield12_value'}';\n");

    print (GW "\$merchant_live_mode = \"$in{'live_mode'}\";\n");
    print (GW  "1\;\n");
    close(GW);
  }
}
##############################################################################
sub PlugnPay_mgr_check {
  if ($sc_gateway_name eq "PlugnPay") {
    &print_PlugnPay_mgr_form;
    &call_exit;
  }
}
##############################################################################
sub print_PlugnPay_mgr_form {
	
##
## PLUGNPAY.COM
##

print &$manager_page_header("PlugnPay Gateway","","","","");

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=580>
  <TR>
    <TD COLSPAN=2><HR></TD>
  </TR>

  <TR>
    <TD WIDTH=580><FONT FACE=ARIAL>$sc_gateway_name Settings $msg</FONT></TD>
  </TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "") {
  print <<ENDOFTEXT;
<CENTER>
<TABLE>
  <TR>
    <TD>
      <FONT FACE=ARIAL SIZE=2 COLOR=RED>Gateway settings have been successfully updated</FONT>
    </TD>
  </TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 WIDTH=580 BORDER=0>

  <TR>
    <TD COLSPAN=2><HR></TD>
  </TR>

  <TR>
    <TD width=80%>Are you ready to go live?
      <br><font size="-1">(Answer "no" to run in test mode)</font></TD>
    <TD align="right"><SELECT NAME="live_mode">
      <OPTION>$merchant_live_mode</OPTION>
      <OPTION>yes</OPTION>
      <OPTION>no</OPTION>
      </SELECT></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><font size="-1"><i>* Note: When running in test mode, you must have your PnP account's Testing Mode enabled.</i></font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><HR></TD>
  </TR>

  <TR>
    <TH COLSPAN=2 bgcolor=#cccccc><b>Required Settings</b></TH>
  </TR>

  <TR>
    <TD width="80%">Plug 'n Pay Username:</td>
    <TD width="20%"><INPUT NAME="sc_gateway_username" TYPE="TEXT" SIZE=30 VALUE='$sc_gateway_username'></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width="80%">Where do you want to receive your email confirmations?</td>
    <TD width="20%"><INPUT NAME="sc_gateway_email" TYPE="TEXT" SIZE=30 VALUE='$sc_gateway_email'></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD COLSPAN=2>Please enter which credit cards you are able to accept.
      <br><font size="-2"><i><u>Example:</u> visa,mastercard,amex,discover,diners,jcb</i></font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align="right"><INPUT NAME="sc_gateway_card_allowed" TYPE="TEXT" SIZE=40 VALUE="$sc_gateway_card_allowed"></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD COLSPAN=2>Please enter your Payment Methods?
      <br><font size="-1"><i>* Note: Leave blank for credit cards only.  Multiple methods are separated via a "|".</i></font>
      <br><font size="-1"><i>Allowed Values: "onlinecheck" for ACH payments, "credit" or blank for Credit Card Purchases.</i></font>
      <br><font size="-2"><i><u>Example:</u> credit|onlinecheck</i></font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align="right"><INPUT NAME="sc_gateway_paymethod" TYPE="TEXT" SIZE=30 VALUE='$sc_gateway_paymethod'></TD>
  </TR>

  <TR>
    <TH COLSPAN=2 bgcolor=#cccccc><b>Email Options</b></TH>
  </TR>

  <TR>
    <TD COLSPAN=2 width="80%">Where do you want to CC your email confirmations?</TD>
  </TR>

  <TR>
    <TD><font size="-1"><i>* Note: Leave blank to not CC email confirmations.</i></font></td>
    <TD width="20%"><INPUT NAME="sc_gateway_cc_mail" TYPE="TEXT" SIZE=30 VALUE='$sc_gateway_cc_mail'></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width=80%>Do you want PnP to send a confirmation email to your customers?</TD>
    <TD align="right"><SELECT NAME="sc_gateway_dontsendmail">
      <OPTION>$sc_gateway_dontsendmail</OPTION>
      <OPTION>yes</OPTION>
      <OPTION>no</OPTION>
      </SELECT></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width="80%">Subject line of email sent to merchant:
      <br><font size="-1"><i>* Note: Leave blank for default subject.</i></font></TD>
    <TD width="20%"><INPUT NAME="sc_gateway_subject" TYPE="TEXT" SIZE=30 VALUE='$sc_gateway_subject'></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width="80%">Additional message to include in email sent to customer:
      <br><font size="-1"><i>* Note: Leave blank for no additional message.</i></font></TD>
    <TD width="20%"><INPUT NAME="sc_gateway_message" TYPE="TEXT" SIZE=30 VALUE='$sc_gateway_message'></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width="80%">Subject line of email sent to customer:
      <br><font size="-1"><i>* Note: Leave blank for default subject.</i></font></TD>
    <TD width="20%"><INPUT NAME="sc_gateway_subject_email" TYPE="TEXT" SIZE=30 VALUE='$sc_gateway_subject_email'></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><font size="-1"><b>For more advanced email confirmation options, see the "Email Management" section of your PnP admin area.</b></font></TD>
  </TR>

  <TR>
    <TH COLSPAN=2 bgcolor=#cccccc><b>Misc. Options</b></TH>
  </TR>

  <TR>
    <TD>Please enter the AVS level you want to use:
      <br><font size="-2"><i><u>Example:</u> '0', '1', '2', '3', '4', '5', '6'</i></font></TD>
    <TD align="right"><INPUT NAME="sc_gateway_avs_level" TYPE="TEXT" SIZE=2 VALUE="$sc_gateway_avs_level"></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width=80%>Do you want to include a comments box on your billing page?</TD>
    <TD align="right"><SELECT NAME="sc_gateway_comments">
      <OPTION>$sc_gateway_comments</OPTION>
      <OPTION>yes</OPTION>
      <OPTION>no</OPTION>
      </SELECT></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width=80%>Do you want PnP to calculate sales tax?</TD>
    <TD align="right"><SELECT NAME="sc_gateway_calculate_tax">
      <OPTION>$sc_gateway_calculate_tax</OPTION>
      <OPTION>yes</OPTION>
      <OPTION>no</OPTION>
      </SELECT></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><font size="-1">If you answered "yes", please answer the below questions:</font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center>&nbsp;</TD>
  </TR>

  <TR>
    <TD COLSPAN=2>Enter your sales tax rate:
      <br><font size="-1"><i>* Notes: "1.00" equals 100% sales tax.  Multiple tax rates are separated via a "|".</i></font>
      <br><font size="-2"><i><u>Example:</u> enter "0.085" for 8.5% sales tax or "0.085|0.075" for multiple tax rates.</i></font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align="right"><INPUT NAME="sc_gateway_taxrate" TYPE="TEXT" SIZE=20 VALUE="$sc_gateway_taxrate"></TD>
  </TR>

  <TR>
    <TD COLSPAN=2>Enter your sales tax state:
      <br><font size="-1"><i>* Notes: Use the 2 letter abbreviation for your state.  Multiple tax states are separated via a "|".</i></font>
      <br><font size="-2"><i><u>Example:</u> enter "NY" for New York or "NY|TX" for New York & Texas</i></font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align="right"><INPUT NAME="sc_gateway_taxstate" TYPE="TEXT" SIZE=20 VALUE="$sc_gateway_taxstate"></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width=80%>Display contents of order on payment page and in email to customer and merchant?</TD>
    <TD align="right"><SELECT NAME="sc_gateway_easycart">
      <OPTION>$sc_gateway_easycart</OPTION>
      <OPTION>yes</OPTION>
      <OPTION>no</OPTION>
      </SELECT></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><font size="-1"><i>* Note: Must be set to "yes" when using PnP's shipping calculator.</i></font></TD>
  </TR>

  <TR>
    <TH COLSPAN=2 bgcolor=#cccccc><b>Shipping Options</b></TH>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width=80%>Do you want to ask for shipping information?
      <br><font size="-1">(Answer "no" for billing information only.)</font></TD>
    <TD align=right><SELECT NAME=sc_gateway_shipinfo>
      <OPTION>$sc_gateway_shipinfo</OPTION>
      <OPTION>yes</OPTION>
      <OPTION>no</OPTION>
      </SELECT></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width=80%>Do you want to send product weights to PnP?</TD>
    <TD align=right><SELECT NAME=sc_gateway_send_weight>
      <OPTION>$sc_gateway_send_weight</OPTION>
      <OPTION>yes</OPTION>
      <OPTION>no</OPTION>
      </SELECT></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><font size="-1">(Answer "yes", if using PnP's Shipping Calculator. All others should answer "No".)</font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD width=80%>Do you want to use PnP's Shipping Calculator?</TD>
    <TD align=right><SELECT NAME=sc_gateway_use_shipping_calculator>
      <OPTION>$sc_gateway_use_shipping_calculator</OPTION>
      <OPTION>yes</OPTION>
      <OPTION>no</OPTION>
      </SELECT></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><font size="-1"><i>If you selected "yes", fill in the below fields as necessary.</i></font>
      <br><font size="-1"><i>Any unneeded fields, leave blank.</i></font>
      <br><font size="-1"><i>See PnP's Shipping Calculator documentation for field details & meanings.</i></font></TD>
  </TR>

  <TR>
    <TD align=right>shipmethod</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_shipmethod VALUE="$sc_gateway_shipmethod"></TD>
  </TR>

  <TR>
    <TD align=right>merchant-zip</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_merchant_zip VALUE="$sc_gateway_merchant_zip"></TD>
  </TR>

  <TR>
    <TD align=right>usps-container</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_usps_container VALUE="$sc_gateway_usps_container"></TD>
  </TR>

  <TR>
    <TD align=right>usps-size</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_usps_size VALUE="$sc_gateway_usps_size"></TD>
  </TR>

  <TR>
    <TD align=right>ups-rate-chart</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_ups_rate_chart VALUE="$sc_gateway_ups_rate_chart"></TD>
  </TR>

  <TR>
    <TD align=right>mailtype</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_mailtype VALUE="$sc_gateway_mailtype"></TD>
  </TR>

  <TR>
    <TD align=right>machinable</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_machinable VALUE="$sc_gateway_machinable"></TD>
  </TR>

  <TR>
    <TD align=right>rate-chart</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_rate_chart VALUE="$sc_gateway_rate_chart"></TD>
  </TR>

  <TR>
    <TD align=right>method-allow</TD>
    <TD align=right><INPUT TYPE=TEXT NAME=sc_gateway_method_allow VALUE="$sc_gateway_method_allow"></TD>
  </TR>

  <TR>
    <TH COLSPAN=2 bgcolor=#cccccc><b>URL Linking Options</b></TH>
  </TR>

  <TR>
    <TD COLSPAN=2>Please enter your success-link (Thank You web page/script) URL:
      <br><font size="-1"><i>* Note: Leave blank to point back to the Agora Cart shopping cart script</i></font>
      <br><font size="-2"><i><u>Example:</u> http://www.mysite.com/thanks.html or http://www/mysite.com/thanks.cgi</i></font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align="right"><INPUT NAME="sc_gateway_success_link" TYPE="TEXT" SIZE=40 VALUE="$sc_gateway_success_link"></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD COLSPAN=2>Please enter your badcard-link (Transaction declined web page/script) URL:
      <br><font size="-1"><i>* Note: Leave blank to point back to PnP's billing interface (RECOMMENDED)</i></font>
      <br><font size="-2"><i><u>Example:</u> http://www.mysite.com/badcard.html or http://www/mysite.com/badcard.cgi</i></font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align="right"><INPUT NAME="sc_gateway_badcard_link" TYPE="TEXT" SIZE=40 VALUE="$sc_gateway_badcard_link"></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align=center><HR width=80%></TD>
  </TR>

  <TR>
    <TD COLSPAN=2>Please enter your problem-link (Transaction problem web page/script) URL:
      <br><font size="-1"><i>* Note: Leave blank to point back to PnP's billing interface (RECOMMENDED)</i></font>
      <br><font size="-2"><i><u>Example:</u> http://www.mysite.com/problem.html or http://www/mysite.com/problem.cgi</i></font></TD>
  </TR>

  <TR>
    <TD COLSPAN=2 align="right"><INPUT NAME="sc_gateway_problem_link" TYPE="TEXT" SIZE=40 VALUE="$sc_gateway_problem_link"></TD>
  </TR>

  <TR>
    <TH COLSPAN=2 bgcolor=#cccccc><b>User Defined Fields</b></TH>
  </TR>

  <TR>
    <TD COLSPAN=2>User defined fields extends your PnP checkout abilities.  This feature allows for use of new features as they become available.  Simply set the variable's name/value parameters for new features & settings below.
      <br><font size="-1"><i>Leave fields blank, if unneeded.</i></font></TD>
  </TR>

  <TR>
    <TD align="right"><i>Variable Name</i></TD>
    <TD align="right"><i>Variable Value</i></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield1_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield1_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield1_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield1_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield2_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield2_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield2_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield2_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield3_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield3_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield3_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield3_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield4_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield4_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield4_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield4_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield5_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield5_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield5_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield5_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield6_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield6_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield6_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield6_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield7_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield7_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield7_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield7_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield8_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield8_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield8_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield8_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield9_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield9_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield9_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield9_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield10_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield10_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield10_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield10_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield11_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield11_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield11_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield11_value"></TD>
  </TR>

  <TR>
    <TD align="right"><INPUT NAME="sc_gateway_userfield12_name" TYPE=TEXT SIZE=20 VALUE="$sc_gateway_userfield12_name"></TD>
    <TD align="right"><INPUT NAME="sc_gateway_userfield12_value" TYPE=TEXT SIZE=25 VALUE="$sc_gateway_userfield12_value"></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><HR></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><CENTER>
      <INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
      <INPUT TYPE="HIDDEN" NAME="gateway" VALUE="$sc_gateway_name">
      <INPUT NAME="GatewaySettings" TYPE="SUBMIT" VALUE="Submit">
      &nbsp;&nbsp;
      <INPUT TYPE="RESET" VALUE="Reset">
      </CENTER></TD>
  </TR>

  <TR>
    <TD COLSPAN=2><HR></TD>
  </TR>
</TABLE>

</CENTER>
</FORM>
ENDOFTEXT
print &$manager_page_footer;
}
##############################################################################
1; #Library