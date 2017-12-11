require 'mysql2'

SCHEDULER.every '5m', :first_in => 0 do |job|

  # Myql connection
  db = Mysql2::Client.new(:host => "midgard", :username => "matt", :port => 3306, :database => "cms" )

  # Mysql query
  sql = "SELECT ID, COUNT( ID ) AS count FROM component LIMIT 1"

  # Execute the query
  results = db.query(sql)

  # Sending to List widget, so map to :label and :value
  acctitems = results.map do |row|
    row = {
      :label => row['ID'],
      :value => row['count']
    }
  end

  # Update the List widget
  send_event('component_id', { items: acctitems } )

end
