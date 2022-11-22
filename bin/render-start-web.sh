echo "RENDER-START-WEB.SH"
eval $( echo VAR="FOO" )
echo $VAR
bundle exec puma -C config/puma.rb