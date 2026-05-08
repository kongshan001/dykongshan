# 陷阱记录
1. datetime.now(tz)之间做差不能得到UTC偏移，需用utcoffset()
2. zoneinfo是Python 3.9+才有的标准库
