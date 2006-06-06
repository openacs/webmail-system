<!---------------------------------------------------------------->
<!--                         PROGRESS BAR                       -->
<!--                                                            -->
<!-- LOCATION: www/template/progress-bar.adp                    -->
<!-- AUTHOR: Nima Mazloumi                                      -->
<!-- CREATION DATE: 14/08/2004                                  -->
<!---------------------------------------------------------------->

<master src="../templates/master-template">
<property name="title">@title@</property>

<table width="800">
<tr><td>
<div id="page-body">
  <if @title@ not nil>
    <h2 class="page-title">@title;noquote@</h2>
  </if>

  <div class="boxed-user-message">
    <if @message_1@ not nil>
      <p align="center">@message_1@</p>
    </if>
    <p align="center">
      <span id="progress1" style="background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
      <span id="progress2" style="background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
      <span id="progress3" style="background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
      <span id="progress4" style="background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
      <span id="progress5" style="background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
    </p>
    <if @message_2@ not nil>
      <p align="center">@message_2@</p>
    </if>
  </table>

  <div style="clear: both;"></div>
</div>
</td>
</tr>
</table>

<script language="javascript">
var progressEnd = 5;// set to number of progress <span>'s.
var progressColor = 'blue';// set to progress bar color
var progressInterval = 1000;// set to time between updates (milli-seconds)

var progressAt = progressEnd;
var progressTimer;
function progress_update() {
    if (progressAt > 0) {
        document.getElementById('progress'+progressAt).style.backgroundColor = 'white';
    }
    progressAt++;
    if (progressAt > progressEnd) progressAt = 1;
    document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;

    // schedule progress bar to update automatically
    progressTimer = setTimeout('progress_update()',progressInterval);
}

progress_update();// start progress bar
</script>