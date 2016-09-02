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

      UserAdminCli.new.toggle_admin(email)
      Rake::Task['user:admin:list'].invoke
    end
  end

  namespace :team_leader do
    desc 'Prints a list of teamn leader users'
    task list: :environment do
      team_leaders = UserAdminCli.new.team_leaders

      puts 'Configured Team Leaders:'

      if team_leaders.empty?
        puts 'There are no administrative users'
      else
        puts team_leaders
      end
    end

    desc 'Toggle a user to / from a team leader'
    task toggle: :environment do
      unless email = ENV['EMAIL'] # rubocop:disable Lint/AssignmentInCondition
        abort 'Usage: bundle exec rake user:team_leader:toggle EMAIL="someone@example.com"'
      end

      UserAdminCli.new.toggle_team_leader(email)
      Rake::Task['user:team_leader:list'].invoke
    end
  end
end
