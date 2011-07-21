# encoding: utf-8
# 日期、时间格式定义都放在此文件
Time::DATE_FORMATS.merge!(
  :serial => "%Y%m%d",
  :full => "%Y-%m-%d %H:%M:%S",
  :with_year => "%Y-%m-%d %H:%M",
  :short => "%m-%d %H:%M"
)

Date::DATE_FORMATS.merge!(
  :month_and_day => "%m-%d"
)
