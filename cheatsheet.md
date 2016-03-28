#mclock - Cheatsheet

##What are all the timezones available

<table>
    <tr><td>ADT = "America/Halifax" </td>
<td>AKDT = "America/Juneau" </td>
<td>AKST = "America/Juneau" </td>
</tr><tr><td>ART = "America/Argentina/Buenos_Aires" </td>
<td>AST = "America/Halifax" </td>
<td>BDT = "Asia/Dhaka" </td>
</tr><tr><td>BRST = "America/Sao_Paulo" </td>
<td>BRT = "America/Sao_Paulo" </td>
<td>BST = "Europe/London" </td>
</tr><tr><td>CAT = "Africa/Harare" </td>
<td>CDT = "America/Chicago" </td>
<td>CEST = "Europe/Paris" </td>
</tr><tr><td>CET = "Europe/Paris" </td>
<td>CLST = "America/Santiago" </td>
<td>CLT = "America/Santiago" </td>
</tr><tr><td>COT = "America/Bogota" </td>
<td>CST = "America/Chicago" </td>
<td>EAT = "Africa/Addis_Ababa" </td>
</tr><tr><td>EDT = "America/New_York" </td>
<td>EEST = "Europe/Istanbul" </td>
<td>EET = "Europe/Istanbul" </td>
</tr><tr><td>EST = "America/New_York" </td>
<td>GMT = GMT </td>
<td>GST = "Asia/Dubai" </td>
</tr><tr><td>HKT = "Asia/Hong_Kong" </td>
<td>HST = "Pacific/Honolulu" </td>
<td>ICT = "Asia/Bangkok" </td>
</tr><tr><td>IRST = "Asia/Tehran" </td>
<td>IST = "Asia/Calcutta" </td>
<td>JST = "Asia/Tokyo" </td>
</tr><tr><td>KST = "Asia/Seoul" </td>
<td>MDT = "America/Denver" </td>
<td>MSD = "Europe/Moscow" </td>
</tr><tr><td>MSK = "Europe/Moscow" </td>
<td>MST = "America/Denver" </td>
<td>NZDT = "Pacific/Auckland" </td>
</tr><tr><td>NZST = "Pacific/Auckland" </td>
<td>PDT = "America/Los_Angeles" </td>
<td>PET = "America/Lima" </td>
</tr><tr><td>PHT = "Asia/Manila" </td>
<td>PKT = "Asia/Karachi" </td>
<td>PST = "America/Los_Angeles" </td>
</tr><tr><td>SGT = "Asia/Singapore" </td>
<td>UTC = UTC </td>
<td>WAT = "Africa/Lagos" </td>
</tr><tr><td>WEST = "Europe/Lisbon" </td>
<td>WET = "Europe/Lisbon" </td>
<td>WIT = "Asia/Jakarta" </td>
    </tr>
    <tr><td><mark>UTC+10 for Bali</mark> </td>
<td><mark>GMT+10 for Brisbane </mark> </td>
<td><mark>UTC-330 for Canada/Newfoundland </mark> </td>
    </tr>
</table>



##How to change what to display

<table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
    <tbody><tr>
      <th width="50%">Pattern</th>
      <th width="50%">Result (in a particular locale)</th>
    </tr>
    <tr>
      <td width="50%">yyyy.MM.dd G 'at' HH:mm:ss zzz</td>
      <td width="50%">1996.07.10 AD at 15:08:56 PDT</td>
    </tr>
    <tr>
      <td width="50%">EEE, MMM d, ''yy</td>
      <td width="50%">Wed, July 10, '96</td>
    </tr>
    <tr>
      <td width="50%">h:mm a</td>
      <td width="50%">12:08 PM</td>
    </tr>
    <tr>
      <td width="50%">hh 'o''clock' a, zzzz</td>
      <td width="50%">12 o'clock PM, Pacific Daylight Time</td>
    </tr>
    <tr>
      <td width="50%">K:mm a, z</td>
      <td width="50%">0:00 PM, PST</td>
    </tr>
    <tr>
      <td width="50%">yyyyy.MMMM.dd GGG hh:mm aaa</td>
      <td width="50%">01996.July.10 AD 12:08 PM</td>
    </tr>
  </tbody></table>

Source: [Unicode.org](http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns)
