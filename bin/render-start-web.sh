echo "RENDER-START-WEB.SH"

testfunc() {
	echo "THIS IS IN TEST FUNC"
}

eval $(testfunc)
bundle exec puma -C config/puma.rb