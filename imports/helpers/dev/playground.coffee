obj = a: 1
b= obj

str = "a: #{b.a}"

obj.a = 2

console.log str, b


