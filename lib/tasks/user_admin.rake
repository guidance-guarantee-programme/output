# frozen_string_literal: true
namespace :user do
  namespace :admin do
    desc 'Prints a list of administrative users'
    task list: :environment do
      admins = UserAdminCli.new.admins

      if admins.empty?
        puts 'There are no administrative users'
      else
        puts admins
      end
    end
  end
end
