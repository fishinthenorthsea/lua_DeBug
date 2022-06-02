Debug库

# debug库这些函数的封装
## （1）Getalllocal()          打印所有local
## （2）Getallupvalue()        打印所有upvalue
## （3）GetTrace()             打印堆栈信息
## （4）Getlocal(key)          打印对应局部变量的value
## （5）Getupvalue(key)        打印对应上值的value
## （6）debug()                进入调试模式   --->配合pl pu使用
## （7）Setlocal(key,value)    改变对应局部变量的value
## （8）Setupvalue(key,value)  改变对应上值的value





# 局部函数：
## 1.file_write(res)   对文件进行写入res
## 2.getfirst()        获得时间 + 文件 + 行数 的字符串
## 3.pl(res)           调试模式使用---输出对应局部变量的value
## 4.pu(res))          调试模式使用---输出对应上值的value