require 'mysql2'

points = []
(1..10).each do |i|
  points << { x: i, y: rand(50) }
end
last_x = points.last[:x]

SCHEDULER.every '5m', :first_in => 0 do |job|

  # Myql connection
  db = Mysql2::Client.new(:host => "midgard", :username => "matt", :port => 3306, :database => "cms" )

  # Mysql query
  sql = "SELECT COUNT( ID ) AS count FROM component"

  # Execute the query
  results = db.query(sql)
  returnVal = 0
  acctitems = results.map do |row|
    row = {
      returnVal => row['count']
    }
  end
  puts "ID count #{returnVal}"

  points.shift
  last_x += 1
  puts "x is #{last_x}"
  points << { x: last_x, y: returnVal }

  puts "ID count #{points}"

  send_event('component-count', points: points)
end
