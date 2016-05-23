every '0 5 * * *' do
  rake 'tweet:all'
end

every '0 7 * * *' do
  rake 'tweet:breakfast'
end

every '30 11 * * *' do
  rake 'tweet:lunch'
end

every '30 17 * * *' do
  rake 'tweet:dinner'
end
