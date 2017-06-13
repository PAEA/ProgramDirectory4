// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).on("scroll", function(){
    if ($(document).scrollTop() > 50){
      $(".info-hed").addClass("infohed-shrink");
        if ($(window).width() < 768) {
            $("header").addClass("header-shrink");
            $(".logo-text").addClass("logotext-shrink");
        } else {
            $("header").removeClass("header-shrink");
            $(".logo-text").removeClass("logotext-shrink");
        }
        if ($(window).width() < 600) {
            $(".desktop-header").remove();
        }
    }
    else
    {
        $(".info-hed").removeClass("infohed-shrink");
    }
});
