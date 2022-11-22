echo "RENDER-START-CRON.SH"

testfunc() {
	echo "errno=12345"
	return 1
}

eval $(testfunc)
echo $errno

echo "THIS IS A CRON"