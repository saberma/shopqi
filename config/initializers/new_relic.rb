# encoding: utf-8
# Ensure the agent is started using Unicorn
# This is needed when using Unicorn and preload_app is not set to true.
# See https://newrelic.tenderapp.com/help/kb/troubleshooting/im-using-unicorn-and-i-dont-see-any-data
NewRelic::Agent.after_fork(force_reconnect: true) if defined? Unicorn
