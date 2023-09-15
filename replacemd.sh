#!/bin/bash  
  
# 检查参数是否为文件夹  
if [ ! -d "$1" ]; then  
  echo "参数必须为文件夹！"  
  exit 1  
fi  
  
# 遍历文件夹和子文件夹中的所有.md文件  
find "$1" -name "*.md" | while read -r file; do  
  # 读取文件内容并替换第一个"---"为"<!---"，第二个"---"为"--->"  
  content=$(cat "$file")  
  content=${content/---/<!--}  
  content=${content/---/-->}  
  
  # 将替换后的内容写回文件  
  echo "$content" > "$file"  
done
