require "./initialize"

app = App.new
args = (ARGV.empty?) ? ["-h"] : ARGV
app.parse_cli(args: args)
