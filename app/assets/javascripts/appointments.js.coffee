# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$("#appointment_department_id").change -> 
	department_id = $(this).val()
	$.get '/practitioners_by_department', {department_id}, 
		(data) -> data,
	'js'
