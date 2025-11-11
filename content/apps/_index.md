+++
title = "Links"
date = "2023-09-13T21:26:26Z"
author = "Frederik Beimgraben"
authorTwitter = "" #do not include @
cover = ""
tags = ["apps", "services"]
description = "Available Apps and Services"
showFullContent = false
readingTime = false
hideComments = false
color = "" #color from the theme settings
+++

{{< rawhtml >}}
<style>
h1 {
    display: none;
}
</style>

<!--
New Version: Grid of Apps with icon and text below it
The grid keeps itself and the elements centered and wraps if the screen is too small
-->

<style>
.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, 200px);
  grid-gap: 40px;
  padding: 40px;
  width: 100%;
  justify-content: center;

}

.grid-item {
  text-align: center;
  font-size: 20px;
  color: #ffffff;
  padding: 35px;
  height: 200px;
  width: 200px;
  align-items: center center;
  border-radius: 25px;
}

.app {
    color: #ffffff;
    text-decoration: none;
    font-size: 20px;
    font-weight: bold;
}
</style>

<div class="grid-container">
  <div class="grid-item">
  <!--Hide line under Text-->
    <a href="https://mail.beimgraben.net" target="_blank" class="app">
        <center>
        <img src="/img/mail_plain.svg" alt="Mail" width="100px" height="100px">
        Mailserver
        </center>
    </a>
  </div>
  <div class="grid-item">
    <a href="https://mail.beimgraben.net/SOGo" target="_blank" class="app">
        <center>
        <img src="/img/sogo_plain.svg" alt="SOGo" width="100px" height="100px">
        Webmail
        </center>
    </a>
  </div>
  <!--div class="grid-item">
    <a href="https://jagdmodelle.beimgraben.net" target="_blank" class="app">
        <center>
        <img src="/img/hfr_plain.svg" alt="Jagdmodelle" width="100px" height="100px">
        Jagdmodelle
        </center>
    </a>
  </div-->
  <div class="grid-item">
    <a href="https://cloud.beimgraben.net" target="_blank" class="app">
        <center>
        <img src="https://cloud.beimgraben.net/core/img/logo/logo.svg" alt="Jagdmodelle" width="100px" height="100px">
        Nextcloud
        </center>
    </a>
  </div>
</div>


{{< /rawhtml >}}
