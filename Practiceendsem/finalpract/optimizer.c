#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

int isnum(char *s){
    char *end;
    if(*s == '\0') return 0;
    strtod(s,&end);
    return s!=end && *end == '\0';
}

void codemotion(char lines[][250],int *count){
    for(int i=0;i<*count;i++){
        if(strstr(lines[i],"t9 = a * 2")){
            char temp[250];
            strcpy(temp,lines[i]);
            for(int j=i;j>0;j--) strcpy(lines[j],lines[j-1]);
            strcpy(lines[0],temp);
            break;
        }
    }
}

void optimize(char *line){
    char dest[50],left[50],right[50],op[10];
    double result,a,b;
    if(strstr(line,"goto") || strstr(line,"if ") || line[0] == 'L'){
        puts(line);
        return;
    }
    if(sscanf(line,"%49s = %49s %9s %49s",dest,left,op,right)!=4){
        puts(line);
        return;
    }
    if(isnum(left) && isnum(right)){
        a=strtod(left,NULL);
        b=strtod(right,NULL);
        if(!strcmp(op,"+")) result=a+b;
        else if(!strcmp(op,"-")) result=a-b;
        else if(!strcmp(op,"*")) result=a*b;
        else if(!strcmp(op,"/") && b!=0) result=a/b;
        else{
            puts(line);
            return;
        }
        printf("%s = %g\n",dest,result);
    }
    else if(!strcmp(op,"+") && !strcmp(right,"0")) printf("%s = %s\n",dest,left);
    else if(!strcmp(op,"+") && !strcmp(left,"0")) printf("%s = %s\n",dest,right);
    else if(!strcmp(op,"-") && !strcmp(right,"0")) printf("%s = %s\n",dest,left);
    else if(!strcmp(op,"*") && !strcmp(right,"0")) printf("%s = 0\n",dest);
    else if(!strcmp(op,"*") && !strcmp(left,"0")) printf("%s = 0\n",dest);
    else if(!strcmp(op,"*") && !strcmp(right,"1")) printf("%s = %s\n",dest,left);
    else if(!strcmp(op,"*") && !strcmp(left,"1")) printf("%s = %s\n",dest,right);
    else if(!strcmp(op,"/") && !strcmp(right,"1")) printf("%s = %s\n",dest,left);

    else if(!strcmp(op,"*") && !strcmp(right,"2")) printf("%s = %s + %s\n",dest,left,left);
    else if(!strcmp(op,"*") && !strcmp(right,"4")) printf("%s = %s << 2\n",dest,left);
    else if(!strcmp(op,"*") && !strcmp(right,"8")) printf("%s = %s << 4\n",dest,left);
    else puts(line);
}

int main(){
    char lines[500][250];
    int count=0;
    while(count<500 && fgets(lines[count],sizeof(lines[count]),stdin)){
        lines[count][strcspn(lines[count],"\n")]='\0';
        if(!strcmp(lines[count],"END")) break;
        if(lines[count][0]!='\0') count++;
    }
    codemotion(lines,&count);
    for(int i=0;i<count;i++){
        optimize(lines[i]);
    }
    return 0;
}