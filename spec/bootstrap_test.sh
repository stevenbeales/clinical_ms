echo "started running bootstrap test ..."

echo "setting test env"
export RAILS_ENV=test

echo "seeding data"
rake db:seed

echo "finished running bootstrap test"
