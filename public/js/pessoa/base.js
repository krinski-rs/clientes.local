$(document).ready(
	function(){
		$('.pessoa_fisica').click(
			function(event){
				event.stopPropagation();
				console.log('click!!!');
				$.ajax({
					method: 'POST',
					url: '/table',
					data: [
						{
							name:'title', value:'Listagem de Pessoa Física'
						}
					],
					dataType: 'html'
				}).done(
					function( content ) {
						$('#content').remove();
						$('#left').after(content);
						$('#chitos').dataTable();

					}
				).fail(
					function( jqXHR, textStatus ) {
						alert( "Request failed: " + textStatus );
					}
				);
			}
		);
	}
);