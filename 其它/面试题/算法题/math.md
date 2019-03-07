### 有序数组合并
将有序数组 {1,4,6,7,9} 和 {2,3,5,6,8,9,10,11,12} 合并为
{1,2,3,4,5,6,6,7,8,9,9,10,11,12}

~~~
int * mergeArray(int *a, int size1, int *b, int size2) {
    int index1 = 0;
    int index2 = 0;
    int index = 0;
    int *result = malloc(size1 + size2);
    
    while (index1 < size1 && index2 < size2) {
        if (a[index1] < b[index2]) {
            result[index++] = a[index1++];
        }else {
            result[index++] = b[index2++];
        }
    }
    
    while (index1 < size1) {
        result[index++] = a[index1++];
    }
    
    while (index2 < size2) {
        result[index++] = b[index2++];
    }
    
    return result;
}

void test() {
 int arr[] = {1,4,6,7,9};
    int brr[] = {2,3,5,6,8,9,10,11,12};
    int *result = mergeArray(arr,5,brr,9);
    for (int i = 0; i < 14; i++) {
        printf("%d",result[i]);
    }
}
~~~

### 字符串逆转
给定字符串 "hello,world",输出 "dlrow,olleh"

在遍历过程中逐步交换 begin 和 end 俩个指针指向的内容,实现内容翻转

~~~
void char_reverse(char* cha) {
    char *begin = cha;
    char *end = cha + strlen(cha) - 1;
    while (begin < end) {
        char tmp = *begin;
        *begin = *end;
        *end = tmp;
        
        *(begin++);
        *(end--);
    }
}

void test() {
    char arr[] = "hello,world";
    char_reverse(arr);
    printf("%s",arr);

}
~~~

### 快速从数组中找出最大数和第二大数

~~~

~~~
