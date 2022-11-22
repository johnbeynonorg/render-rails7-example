echo "RENDER-START-WEB.SH"

testfunc() {
	echo "errno=12345"
	return 1
}

eval $(testfunc)
echo $errno
bundle exec puma -C config/puma.rb