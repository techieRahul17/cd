
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(){
    char line[100],a[50],b[50],c[50],op[10];
    long x,y;
    char *end1,*end2;

    while(fgets(line,sizeof(line),stdin)){
        if(sscanf(line,"%49s = %49s %9s %49s",a,b,op,c)==4){
            x=strtol(b,&end1,10);
            y=strtol(c,&end2,10);

            if(*b && *c && *end1=='\0' && *end2=='\0'){
                if(strcmp(op,"+")==0)
                    printf("%s = %ld\n",a,x+y);
                else if(strcmp(op,"*")==0)
                    printf("%s = %ld\n",a,x*y);
                else
                    printf("%s",line);
            }
            else{
                printf("%s",line);
            }
        }
        else{
            printf("%s",line);
        }
    }

    return 0;
}
