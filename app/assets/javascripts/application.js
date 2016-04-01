// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-datepicker
//= require_tree .
//= require bootstrap

$(document).ready(function() {  
	

	$('[data-toggle="tooltip"]').tooltip(); 
	
	  $("input:radio").click(function(){
	  	
	  	var value = $("input:radio").val()
		//alert($(this).val())
		
		  request = void 0;
		  request = $.ajax({
		  url: "/quizzes/start/?id=3&odgovorid=" + $(this).val()
		  });
		  request.done(function(data, textStatus, jqXHR) {
		    console.log(data);
		  });
		  request.error(function(jqXHR, textStatus, errorThrown) {
		    alert("AJAX Error:" + textStatus);
		  });
		});
	
	/*
	    $(function () {
        $('#datetimepicker6').datetimepicker();
        $('#datetimepicker7').datetimepicker({
            useCurrent: false //Important! See issue #1075
        });
        $("#datetimepicker6").on("dp.change", function (e) {
            $('#datetimepicker7').data("DateTimePicker").minDate(e.date);
        });
        $("#datetimepicker7").on("dp.change", function (e) {
            $('#datetimepicker6').data("DateTimePicker").maxDate(e.date);
        });
    });
	*/
	
//	alert('test')
	$('#quiz_datumstart').click(function()
	{
		//alert('test dtpPicker');
		 $(this).datepicker();
		 $('#quiz_datumstart').datepicker('update');
	});

$('.input-daterange input').each(function() {
    $(this).datepicker("clearDates");
});
	
})
