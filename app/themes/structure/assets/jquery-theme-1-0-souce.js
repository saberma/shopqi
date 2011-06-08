/* Structure Shopify Theme v1.0 (jQuery 1.3.1 required). Copyright (c) Pixellent, LLC <http://www.pixellent.com>. */

// Clear Inputs
$.cleared = function(field) {
	
	if ($(field).length) {
		$(field).each(function() {
			var text = $(this).val();
			$(this).focus(function() { if ($(this).val() == text) { $(this).val(''); }; });
			$(this).blur(function() { if ($(this).val() == '') { $(this).val(text); }; });
		});
	};
	
};

// Validate Email
$.validate = function(form) {
	
	if ($(form).length) {
	
		$(form).submit(function() {
			var action = $(this).attr("action");
			var fname = $(this).find("input#fname").attr("name");
			var lname = $(this).find("input#lname").attr("name");
			var email = $(this).find("input#email").attr("name");
			if (action == "" || fname == "" || lname == "" || email == "") {
				alert("The newsletter form is not configured properly. Update the newsletter settings in the theme editor in your shop admin.");
				return false;
			};
			var subscriber = $(this).find("input#lname").val();
			if (subscriber == "Last Name...") {
				alert("The last name field cannot be blank.");
				$(form).find("input#lname").focus();
				return false;
			};
			var address = $(this).find("input#email").val();
			if (!$.regex(address)) {
				alert("Please enter a valid email address to subscribe.");
				$(form).find("input#email").focus();
				return false;
			};
		});
		
		$.regex = function(email) {
			var regex = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
			return regex.test(email);
		};
		
	};
	
};

// Initialize page elements once the DOM is ready
$(document).ready(function() {
	
	$.cleared("input.field");
	$.validate("li.newsletter form");
	
});