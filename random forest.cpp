//random forest 
#include<cstdio>
#include<iostream> 
#include<sstream>
#include<fstream> 
#include<vector>
#include<string>
#include<cstdlib>
#include<ctime> 
#include<cstring>
#include<algorithm>
using namespace std;
#define M 30 //树的个数
#define m 768 //每次抽取的数量 
#define total 768 //样本个数 
#define num 8 //特征个数 
double data[total][num+1];
struct node{
	int category;
	double edge;
	node(){
		category=edge=-1;
	}
	node(int a,double b){
		category=a;edge=b;
	}
};
node tree[M][1<<(num+2)];
double obb[M];
double te[total];
vector<int> temp[M];
bool mark[num];
bool sign[total];
int mark0[total];
int mark1[total];
vector<node> help1;
vector<double> help2;
double f(string s){
	int i,j,k=1;
	double ans1=0,ans2=0;
	for(i=0;i<s.length();i++)
	   if(s[i]!='.')
	   ans1=ans1*10+s[i]-48;
	   else break;
	for(i++;i<s.length();i++){
		k=k*10;ans2=ans2+(s[i]-48)*1.0/k;
	}
	return ans1+ans2;
}
int find(vector<node> te,double eg){
	int i,j,k,mid,s=0,e=te.size()-1;
	while(s<e){
		mid=(s+e)/2;
		if(te[mid].edge<=eg) s=mid+1;
		else e=mid-1;
	}
	return s;
}
void f(int s,int e){
	int i,j,k;
	node te,t;
	if(s<e){
		i=s-1;te=help1[e];
		for(j=s;j<e;j++)
		if(help1[j].edge<=te.edge){
			i++;t=help1[i];help1[i]=help1[j];help1[j]=t;
		}
		help1[e]=help1[i+1];
		help1[i+1]=te;
		f(s,i);f(i+2,e);
	}
}
void build(int pos,int tepos,vector<int> Q){
	int i,j,k,cate,t=0,leftnum,rightnum,leftcanum,rightcanum,l,s,e;
	double besteg,eg,gn=2,leftgene,rightgene,gene;
    vector<int> Q1;
    vector<int> Q2;
    for(i=0;i<Q.size();i++)
    if(data[Q[i]][num]==0) t++;
    if(t==Q.size()){
    	tree[pos][tepos].category=-2;return;//-2代表类别0 
	}
	if(t==0){
    	tree[pos][tepos].category=-3;return;//-3代表类别1 
	}
	for(i=0;i<num;i++){
		if(mark[i]) continue;
		help1.clear();help2.clear();
		for(j=0;j<Q.size();j++){
			help1.push_back(node(Q[j],data[Q[j]][i]));
			help2.push_back(data[Q[j]][i]);
		}
		f(0,help1.size()-1);
		sort(help2.begin(),help2.end());
		l=unique(help2.begin(),help2.end())-help2.begin();
		if(l==1){
			gene=1-1.0*t*t/(Q.size()*Q.size())-1.0*(Q.size()-t)*(Q.size()-t)/(Q.size()*Q.size());
			if(gene<gn){
				gn=gene;cate=i;besteg=help2[0];
			}
		}
		else{
			s=0;leftcanum=0;
			for(j=0;j<l-1;j++){
				eg=(help2[j]+help2[j+1])/2;
				leftnum=find(help1,eg);rightnum=help1.size()-leftnum;
				for(k=s;k<leftnum;k++)
				if(data[help1[k].category][num]==0) 
				leftcanum++;
				s=leftnum;
				leftgene=1-1.0*leftcanum*leftcanum/(leftnum*leftnum)-1.0*(leftnum-leftcanum)*(leftnum-leftcanum)/(leftnum*leftnum);
				rightcanum=t-leftcanum;
				rightgene=1-1.0*rightcanum*rightcanum/(rightnum*rightnum)-1.0*(rightnum-rightcanum)*(rightnum-rightcanum)/(rightnum*rightnum);
				gene=leftgene*leftnum/Q.size()+rightgene*rightnum/Q.size();
				if(gene<gn){
					gn=gene;cate=i;besteg=eg;
				}
			}
		}
	}
	if(gn==2) return;
	tree[pos][tepos].category=cate;tree[pos][tepos].edge=besteg;
	mark[cate]=true;
	for(i=0;i<Q.size();i++)
	if(data[Q[i]][cate]<=besteg) Q1.push_back(Q[i]);
	else Q2.push_back(Q[i]);
	build(pos,tepos<<1,Q1);
	build(pos,tepos<<1|1,Q2);
	mark[cate]=false;
}
int judge(int pos,int po){
	int i,j,k,st=1;
	while(1){
		if(tree[pos][st].category==-1)
		   return rand()%2;
		if(tree[pos][st].category==-2)
		   return 0;
		if(tree[pos][st].category==-3)
		   return 1;
		if(tree[pos][st].edge>data[po][tree[pos][st].category])
		   st=st<<1;
		else
		   st=st<<1|1;
	}
}
double ob(int pos){
	int i,j,k=0,l=0;
	memset(sign,false,sizeof(sign));
	for(i=0;i<temp[pos].size();i++)
	sign[temp[pos][i]]=true;
	for(i=0;i<total;i++)
	if(!sign[i]){
		j=judge(pos,i);
		if(j==0) mark0[i]++;
		else mark1[i]++;
		k++;
		if(j==data[i][num]) l++;
	}
	return 1.0*l/k;
}
void totalobb(){
	int i,j,k=0;
	for(i=0;i<total;i++){
		j=mark0[i]>mark1[i]?0:1;
		if(j==data[i][num]) k++;
	} 
	printf("total obb:%lf\n",1.0*k/total);
}
int main(){
	int i,j,k=0,t;
	srand(time(NULL));
	ifstream inFile("D:\\diabetes.csv",ios::in);
	string lineStr;
	while(getline(inFile,lineStr)) 
	{
		stringstream ss(lineStr);
		string str;
		t=0;
		while(getline(ss,str,',')){
			data[k][t++]=f(str);
		}
		k++;
	}
    for(i=0;i<M;i++){
    	for(j=0;j<m;j++) temp[i].push_back(rand()%total);
    	memset(mark,false,sizeof(mark));
    	build(i,1,temp[i]);
	}
	for(i=0;i<M;i++)
	printf("第%d棵树的obb:%lf\n",i,ob(i));
	totalobb();
	return 0;
}