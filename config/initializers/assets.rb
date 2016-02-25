Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
Rails.application.config.assets.precompile += %w( govuk_admin_template/favicon.png
                                                  govuk_admin_template/favicon-development.png )
Rails.application.config.assets.version = '1.0'
