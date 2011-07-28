class CreateEnrichedtitles < ActiveRecord::Migration
  def self.up
    create_table :enrichedtitles do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :enrichedtitles
  end
end
