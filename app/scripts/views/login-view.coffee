define ['listen'], (Listen) ->
	Listen.LoginView = Parse.View.extend
		template: 'login'

		events:
			'submit .login-form': 'login'
			'submit .signup-form': 'signup'

		login: (e) ->
			e.preventDefault()
			# boom Parse login, with error handling
			Parse.User.logIn @$('#login-username').val(), @$('#login-password').val(),
				success: (user) ->
					# TODO: Chrome does not prompt to remember password
					Listen.trigger('login')
					Parse.history.navigate '', true
				error: (user, error) =>
					@$('.login-form .error').text("Nice try, bud! Give it another shot.").show()

		signup: (e) ->
			e.preventDefault()
			# create a new user, set fields, and sign them up! so simple.
			user = new Parse.User()
			user.set
				username: @$('#signup-username').val()
				password: @$('#signup-password').val()
			user.signUp null,
				success: (user) ->
					Listen.trigger('login')
					Parse.history.navigate '', true
				error: (user, error) =>
					@$('.signup-form .error').text("#{error.message}").show()

