class ChangeLasterrorFormatInDelayedJobs < ActiveRecord::Migration
  def change
    change_column :delayed_jobs, :last_error, :blob
  end
end
