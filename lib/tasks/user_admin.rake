# frozen_string_literal: true
namespace :user do
  namespace :admin do
    desc 'Prints a list of administrative users'
    task list: :environment do
      admins = UserAdminCli.new.admins

      puts 'Configured Administrators:'

      if admins.empty?
        puts 'There are no administrative users'
      else
        puts admins
      end
    end

    desc 'Toggle a user to / from an administrator'
    task toggle: :environment do
      unless email = ENV['EMAIL'] # rubocop:disable Lint/AssignmentInCondition
        abort 'Usage: bundle exec rake user:admin:toggle EMAIL="someone@example.com"'
      end

      UserAdminCli.new.toggle(email)
      Rake::Task['user:admin:list'].invoke
    end
  end
end
