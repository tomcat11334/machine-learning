#!/bin/bash
left=4
top=4
width=10
height=15
map=()
sig=0
color=7
echo -ne "\033[?25l"
box0_0=(0 0 0 1 1 0 1 1 0 4)

box1_0=(0 1 1 1 2 1 3 1 0 3)
box1_1=(1 0 1 1 1 2 1 3 -1 3)

box2_0=(0 0 1 0 1 1 2 1 0 4)
box2_1=(0 1 0 2 1 0 1 1 0 3)

box3_0=(0 1 1 0 1 1 2 0 0 4)
box3_1=(0 0 0 1 1 1 1 2 0 4)

box4_0=(0 2 1 0 1 1 1 2 0 3)
box4_1=(0 1 1 1 2 1 2 2 0 3)
box4_2=(1 0 1 1 1 2 2 0 -1 3)
box4_3=(0 0 0 1 1 1 2 1 0 4)

box5_0=(0 0 1 0 1 1 1 2 0 3)
box5_1=(0 1 0 2 1 1 2 1 0 3)
box5_2=(1 0 1 1 1 2 2 2 -1 3)
box5_3=(0 1 1 1 2 0 2 1 0 4)

box6_0=(0 1 1 0 1 1 1 2 0 3)
box6_1=(0 1 1 1 1 2 2 1 0 3)
box6_2=(1 0 1 1 1 2 2 1 -1 3)
box6_3=(0 1 1 0 1 1 2 1 0 4)
box_num=(1 2 2 2 4 4 4)
box_set=(${box0_0[*]} ${box1_0[*]} ${box1_1[*]} ${box2_0[*]} ${box2_1[*]} ${box3_0[*]} ${box3_1[*]} ${box4_0[*]} ${box4_1[*]} ${box4_2[*]} ${box4_3[*]} ${box5_0[*]} ${box5_1[*]} ${box5_2[*]} ${box5_3[*]} ${box6_0[*]} ${box6_1[*]} ${box6_2[*]} ${box6_3[*]})
#echo -ne "\033[$30;60H\033[32;43m${#box_set[*]}:${box_set[179]}:${box_set[180]}:${box_set[178]}\033[0m"
#sleep 5
map=()
min=10
max=-1
obox=()
nbox=()
xleft=$(( $left + 2 ))
ytop=$(( $top + 1 ))
otype=0
orotate=0
ntype=0
nrotate=0
ncolor=0
ocolor=0
score=0
level=0
space=`echo -ne "\040"`
esc=`echo -ne "\033"`
enter=`echo -ne "\015"`
for (( i=0 ; i < width*height ;i++ ))
 do 
 map[$i]=-1 
 done
function display()
{ 
local temp i j k te signal
clear
echo -ne "\033[${top};${left}H"
for (( i=0 ; i < (2+width) ; i++ )) 
do
	 echo -ne "\033[32;43m==\033[0m"
done
temp=$(( $top + $height + 1 ))
echo -ne "\033[${temp};${left}H"
for (( i=0 ; i < (2+width) ; i++ ))
do
	echo -ne "\033[32;43m==\033[0m"
done
for (( i=1 ; i <= height ;i++ ))
do
	temp=$(( $i + $top ))
	echo -ne "\033[${temp};${left}H"
	echo -ne "\033[32;43m||\033[0m"
	te=$(( $left + 2 * (1 + ${width}) ))
	echo -ne "\033[${temp};${te}H"
	echo -ne "\033[32;43m||\033[0m"
done
temp=$(($top + ${height}/2 ))
te=$(( $left + 2*(${width}+2) + 6 ))
echo -ne "\033[${temp};${te}H\033[34mscore\033[0m"
temp=$(( $temp + 1 ))
echo -ne "\033[${temp};${te}H\033[34m0\033[0m"
temp=$(($top + ${height}/2 + 2 ))
te=$(( $left + 2*(${width}+2) + 6 ))
echo -ne "\033[${temp};${te}H\033[34mlevel\033[0m"
temp=$(( $temp + 1 ))
echo -ne "\033[${temp};${te}H\033[34m0\033[0m"
#for ((i=0;i<100;i++))
#do
#newbox
#sleep 1
#done
newbox
newbox
trap "sig=20;" 20
trap "sig=21;" 21
trap "sig=22;" 22
trap "sig=23;" 23
trap "sig=24;" 24
trap "sig=25;" 25
while (( 1 ))
do
	for (( i=0 ; i < 21 - level ;i++ ))
	do
	sleep 0.02
	signal=$sig
	sig=0
	if (( signal == 20 ));then strotate; fi
	if (( signal == 21 ));then stleft; fi
	if (( signal == 22 ));then stright; fi
	if (( signal == 23 ));then stdown; fi
	if (( signal == 24 ));then stalldown; fi
	if (( signal == 25 ));then disexit; fi
	done
	stdown	
done
}
function receive()
{
local i j k temp te key pid sTTY
pid=$1
k=1
sTTY=`stty -g`

trap "myexit;" 25
while (( 1 ))
do
	read -s -n 1 key
	if [[ $key == 'w' ]]; then sig=20; fi
	if [[ $key == 'a' ]]; then sig=21; fi
	if [[ $key == 'd' ]]; then sig=22; fi
	if [[ $key == 's' ]]; then sig=23; fi
	if [[ "s${key}s" == "ss" ]]; then sig=24; fi
	if [[ $key == $esc ]]; then
	sig=25
        k=0
        fi
	if (( sig == 20 || sig == 21 || sig == 22 || sig == 23 || sig ==24 || sig == 25 ));then
	kill -${sig} $pid 
	if (( k == 0 ));then
	# echo -ne "\033[?25h"
	myexit  
	return
	 fi
 	fi
done
}
function myexit()
{
local temp te i j k
temp=$(( $top + $height + 4))
te=$left
stty $sTTY
echo -e "\033[?25h"	
exit
}
function disexit()
{
kill -25 $$
local temp te i j k
temp=$(( $top + $height + 3))
te=$left
echo -ne "\033[${temp};${te}H\033[31myou are a rubbish!\033[0m"	
exit
}
point=0
function judge()
{
local i j k temp te
for ((i = 0 ; i < 8 ; i = i + 2 ))
do
	(( j = i + 1 ))	
	(( temp = ytop + ${obox[$i]} + ${obox[8]} ))
	(( te = xleft + 2 * ${obox[$j]} + 2 * ${obox[9]} ))
	#echo -e "$temp $te"
	if (( temp < ytop || temp > ytop + height - 1 || te < xleft || te > xleft + 2 * ( width - 1) )) ; then  return; fi 
	(( k = (temp - ytop) * width + (te-xleft) / 2 ))
	if (( map[$k] != -1 )) ; then return; fi
done
point=1
}
function newbox()
{
local temp te i j k
if (( ${#nbox[@]} != 0 )); then
drawnew 0
#if (( ${#obox[@]} != 0 )); then draw 0 ; fi
ocolor=$ncolor
otype=$ntype
orotate=$nrotate
obox=(${nbox[@]})
#echo -ne "${#obox[@]}"
fi
if (( ${#obox[@]} == 10 )); then
#echo -e "judge is $(judge)"
point=0
judge
if (( point == 1 )) ; then
	draw 1
else
     draw 1
     disexit
fi
fi
ntype=$(( RANDOM % 7 ))
nrotate=$(( RANDOM % ${box_num[$ntype]} ))
ncolor=$(( RANDOM % ${color} ))
if (( ncolor == 0 )); then ncolor=1 ; fi
#echo -ne "\033[$16;60H\033[32;43m:${ntype}:${nrotate}:${ncolor}\033[0m"
nbox=()
if (( ntype == 0 && nrotate == 0 )); then nbox=( ${box0_0[@]} ) ; fi
if (( ntype == 1 && nrotate == 0 )); then nbox=( ${box1_0[@]} ) ; fi
if (( ntype == 1 && nrotate == 1 )); then nbox=( ${box1_1[@]} ) ; fi
if (( ntype == 2 && nrotate == 0 )); then nbox=( ${box2_0[@]} ) ; fi
if (( ntype == 2 && nrotate == 1 )); then nbox=( ${box2_1[@]} ) ; fi
if (( ntype == 3 && nrotate == 0 )); then nbox=( ${box3_0[@]} ) ; fi
if (( ntype == 3 && nrotate == 1 )); then nbox=( ${box3_1[@]} ) ; fi
if (( ntype == 4 && nrotate == 0 )); then nbox=( ${box4_0[@]} ) ; fi
if (( ntype == 4 && nrotate == 1 )); then nbox=( ${box4_1[@]} ) ; fi
if (( ntype == 4 && nrotate == 2 )); then nbox=( ${box4_2[@]} ) ; fi
if (( ntype == 4 && nrotate == 3 )); then nbox=( ${box4_3[@]} ) ; fi
if (( ntype == 5 && nrotate == 0 )); then nbox=( ${box5_0[@]} ) ; fi
if (( ntype == 5 && nrotate == 1 )); then nbox=( ${box5_1[@]} ) ; fi
if (( ntype == 5 && nrotate == 2 )); then nbox=( ${box5_2[@]} ) ; fi
if (( ntype == 5 && nrotate == 3 )); then nbox=( ${box5_3[@]} ) ; fi
if (( ntype == 6 && nrotate == 0 )); then nbox=( ${box6_0[@]} ) ; fi
if (( ntype == 6 && nrotate == 1 )); then nbox=( ${box6_1[@]} ) ; fi
if (( ntype == 6 && nrotate == 2 )); then nbox=( ${box6_2[@]} ) ; fi
if (( ntype == 6 && nrotate == 3 )); then nbox=( ${box6_3[@]} ) ; fi
#k=0
#for (( i=0 ; i<ntype ; i++))
#do
#	((k = k + ${box_num[$i]}))
#done
#((k = k + nrotate))
#for ((i=0 ; i< 10 ; i++))
#do
#	temp=$(( 10*$k + $i ))
#	te=${box_set[${temp}]}
#	nbox[${i}]=$te
#	echo -ne "\033[$16;60H\033[32;43m${i}:${temp}:${box_set[$temp]}:${nbox[${i}]}\033[0m"
#	sleep 1
#done
#echo -ne "\033[$15;60H\033[32;43m${nbox[*]}\033[0m"
#echo -ne "\033[$16;60H\033[32;43m:${nbox[*]}\033[0m"
drawnew 1
#echo -ne ${nbox[@]}
}
function stleft()
{
obox[9]=$(( ${obox[9]} - 1 ))
point=0
judge
if (( point == 1 ));then
obox[9]=$(( ${obox[9]} + 1 ))
draw 0
obox[9]=$(( ${obox[9]} - 1 ))
draw 1
else
obox[9]=$(( ${obox[9]} + 1 ))
fi
}
function stright()
{
obox[9]=$(( ${obox[9]} + 1 ))
point=0
judge
if (( point == 1 ));then
obox[9]=$(( ${obox[9]} - 1 ))
draw 0
obox[9]=$(( ${obox[9]} + 1 ))
draw 1
else
obox[9]=$(( ${obox[9]} - 1 ))
fi
}
function stdown()
{
local i j k temp te
obox[8]=$(( ${obox[8]} + 1 ))
point=0
judge
if (( point == 1 ));then
obox[8]=$(( ${obox[8]} - 1 ))
draw 0
obox[8]=$(( ${obox[8]} + 1 ))
draw 1
else
obox[8]=$(( ${obox[8]} - 1 ))
for (( i=0; i < 8; i = i + 2 ))
do
	(( j = i + 1 ))
	(( temp= (${obox[$i]}+${obox[8]})*width + ${obox[$j]} + ${obox[9]} ))
	map[$temp]=$ocolor
done
min=1000
max=-1
for (( i=0;i < 8; i = i + 2 ))
do
	(( temp = ${obox[$i]}+${obox[8]} ))
	if (( temp > max )) ; then max=$temp ; fi
	if (( temp < min )) ; then min=$temp ; fi	
done
box2map
newbox
fi
}
function stalldown()
{
local i j k temp te
#echo -ne "\033[50;60Henter stall down\033[0m"
for (( i=0 ; i < height ;i++ ))
do
	obox[8]=$(( ${obox[8]} + $i ))
	point=0
	judge
	obox[8]=$(( ${obox[8]} - $i ))	
	if (( point == 0 ));then break; fi
done
(( i = i - 1 ))
draw 0
obox[8]=$(( ${obox[8]} + $i ))
draw 1
for (( i=0; i < 8; i = i + 2 ))
do
	(( j = i + 1 ))
	(( temp= (${obox[$i]}+${obox[8]})*width + ${obox[$j]} + ${obox[9]} ))
	map[$temp]=$ocolor
done
min=1000
max=-1
for (( i=0;i < 8; i = i + 2 ))
do
	(( temp = ${obox[$i]}+${obox[8]} ))
	if (( temp > max )) ; then max=$temp ; fi
	if (( temp < min )) ; then min=$temp ; fi	
done
box2map
newbox
}
function strotate()
{
local i j k temp te
(( orotate = (orotate + 1) % ${box_num[$otype]} ))
temp=${obox[8]}
te=${obox[9]}
#echo -ne "\033[30;60H\033[32;43m${obox[@]}\033[0m"
if (( otype == 0 && orotate == 0 )); then obox=( ${box0_0[@]} ) ; fi
if (( otype == 1 && orotate == 0 )); then obox=( ${box1_0[@]} ) ; fi
if (( otype == 1 && orotate == 1 )); then obox=( ${box1_1[@]} ) ; fi
if (( otype == 2 && orotate == 0 )); then obox=( ${box2_0[@]} ) ; fi
if (( otype == 2 && orotate == 1 )); then obox=( ${box2_1[@]} ) ; fi
if (( otype == 3 && orotate == 0 )); then obox=( ${box3_0[@]} ) ; fi
if (( otype == 3 && orotate == 1 )); then obox=( ${box3_1[@]} ) ; fi
if (( otype == 4 && orotate == 0 )); then obox=( ${box4_0[@]} ) ; fi
if (( otype == 4 && orotate == 1 )); then obox=( ${box4_1[@]} ) ; fi
if (( otype == 4 && orotate == 2 )); then obox=( ${box4_2[@]} ) ; fi
if (( otype == 4 && orotate == 3 )); then obox=( ${box4_3[@]} ) ; fi
if (( otype == 5 && orotate == 0 )); then obox=( ${box5_0[@]} ) ; fi
if (( otype == 5 && orotate == 1 )); then obox=( ${box5_1[@]} ) ; fi
if (( otype == 5 && orotate == 2 )); then obox=( ${box5_2[@]} ) ; fi
if (( otype == 5 && orotate == 3 )); then obox=( ${box5_3[@]} ) ; fi
if (( otype == 6 && orotate == 0 )); then obox=( ${box6_0[@]} ) ; fi
if (( otype == 6 && orotate == 1 )); then obox=( ${box6_1[@]} ) ; fi
if (( otype == 6 && orotate == 2 )); then obox=( ${box6_2[@]} ) ; fi
if (( otype == 6 && orotate == 3 )); then obox=( ${box6_3[@]} ) ; fi
obox[8]=$temp
obox[9]=$te
#echo -ne "\033[31;60H\033[32;43m${obox[@]}\033[0m"
point=0
judge
(( orotate = (orotate - 1 + ${box_num[$otype]} ) % ${box_num[$otype]} ))
if (( otype == 0 && orotate == 0 )); then obox=( ${box0_0[@]} ) ; fi
if (( otype == 1 && orotate == 0 )); then obox=( ${box1_0[@]} ) ; fi
if (( otype == 1 && orotate == 1 )); then obox=( ${box1_1[@]} ) ; fi
if (( otype == 2 && orotate == 0 )); then obox=( ${box2_0[@]} ) ; fi
if (( otype == 2 && orotate == 1 )); then obox=( ${box2_1[@]} ) ; fi
if (( otype == 3 && orotate == 0 )); then obox=( ${box3_0[@]} ) ; fi
if (( otype == 3 && orotate == 1 )); then obox=( ${box3_1[@]} ) ; fi
if (( otype == 4 && orotate == 0 )); then obox=( ${box4_0[@]} ) ; fi
if (( otype == 4 && orotate == 1 )); then obox=( ${box4_1[@]} ) ; fi
if (( otype == 4 && orotate == 2 )); then obox=( ${box4_2[@]} ) ; fi
if (( otype == 4 && orotate == 3 )); then obox=( ${box4_3[@]} ) ; fi
if (( otype == 5 && orotate == 0 )); then obox=( ${box5_0[@]} ) ; fi
if (( otype == 5 && orotate == 1 )); then obox=( ${box5_1[@]} ) ; fi
if (( otype == 5 && orotate == 2 )); then obox=( ${box5_2[@]} ) ; fi
if (( otype == 5 && orotate == 3 )); then obox=( ${box5_3[@]} ) ; fi
if (( otype == 6 && orotate == 0 )); then obox=( ${box6_0[@]} ) ; fi
if (( otype == 6 && orotate == 1 )); then obox=( ${box6_1[@]} ) ; fi
if (( otype == 6 && orotate == 2 )); then obox=( ${box6_2[@]} ) ; fi
if (( otype == 6 && orotate == 3 )); then obox=( ${box6_3[@]} ) ; fi
obox[8]=$temp
obox[9]=$te
#echo -ne "\033[32;60H\033[32;43m${obox[@]}\033[0m"
if (( point == 1 ));then
draw 0
(( orotate = (orotate + 1) % ${box_num[$otype]} ))
if (( otype == 0 && orotate == 0 )); then obox=( ${box0_0[@]} ) ; fi
if (( otype == 1 && orotate == 0 )); then obox=( ${box1_0[@]} ) ; fi
if (( otype == 1 && orotate == 1 )); then obox=( ${box1_1[@]} ) ; fi
if (( otype == 2 && orotate == 0 )); then obox=( ${box2_0[@]} ) ; fi
if (( otype == 2 && orotate == 1 )); then obox=( ${box2_1[@]} ) ; fi
if (( otype == 3 && orotate == 0 )); then obox=( ${box3_0[@]} ) ; fi
if (( otype == 3 && orotate == 1 )); then obox=( ${box3_1[@]} ) ; fi
if (( otype == 4 && orotate == 0 )); then obox=( ${box4_0[@]} ) ; fi
if (( otype == 4 && orotate == 1 )); then obox=( ${box4_1[@]} ) ; fi
if (( otype == 4 && orotate == 2 )); then obox=( ${box4_2[@]} ) ; fi
if (( otype == 4 && orotate == 3 )); then obox=( ${box4_3[@]} ) ; fi
if (( otype == 5 && orotate == 0 )); then obox=( ${box5_0[@]} ) ; fi
if (( otype == 5 && orotate == 1 )); then obox=( ${box5_1[@]} ) ; fi
if (( otype == 5 && orotate == 2 )); then obox=( ${box5_2[@]} ) ; fi
if (( otype == 5 && orotate == 3 )); then obox=( ${box5_3[@]} ) ; fi
if (( otype == 6 && orotate == 0 )); then obox=( ${box6_0[@]} ) ; fi
if (( otype == 6 && orotate == 1 )); then obox=( ${box6_1[@]} ) ; fi
if (( otype == 6 && orotate == 2 )); then obox=( ${box6_2[@]} ) ; fi
if (( otype == 6 && orotate == 3 )); then obox=( ${box6_3[@]} ) ; fi
obox[8]=$temp
obox[9]=$te
draw 1
fi
}
function box2map()
{
local i j k temp te line p q l
#echo -e "\033[60;60Henter box2map\033[0m"
k=0
line=0
for (( i = max ; i >= min;i-- ))
do
	for (( j = 0;j< width ;j++ ))
	do
	(( temp = j+i*width ))
	if (( ${map[$temp]} == -1 )) ; then break; fi
	done
	if (( j < width )) ; then
	if (( line > 0 )) ;then (( score+=2*line-1 )); fi
	line=0
	else
	(( line++ ))
	(( i++ ))
	for (( p = i - 1 ; p > 0 ; p-- ))
	do
		for(( q = 0 ; q < width ; q++ ))
		do
			(( temp = (p-1)*width + q ))
			(( te = p*width + q ))
			map[$te]=${map[$temp]}
		done
		for(( q = 0; q<width; q++ ))
		do
			map[$q]=-1
		done		
	done 
	fi
	(( k++ ))
	if (( k == max - min + 1 ));then 
	if (( line > 0 ));then (( score+=2*line -1 )); fi
	line=0
	break
	fi
done 
drawmap
temp=$(($top + ${height}/2 + 1 ))
te=$(( $left + 2*(${width}+2) + 6 ))
echo -ne "\033[${temp};${te}H\033[34m${score}\033[0m"
if (( score / 10 > level ));then (( level++ )); fi
temp=$(($top + ${height}/2 + 3 ))
echo -ne "\033[${temp};${te}H\033[34m${level}\033[0m"
}
function drawmap()
{
local i j k temp te tx ty
for (( i=0 ; i< height ; i++ ))
do
	for (( j=0 ; j < width ;j++ ))
	do
		(( temp = i*width + j ))
		(( tx = xleft + 2*j ))
		(( ty = ytop + i ))
	 	if (( ${map[$temp]} == -1 )) ; then 
		echo -ne "\033[${ty};${tx}H  \033[0m"
		else
		echo -ne "\033[${ty};${tx}H\033[3${map[$temp]};4${map[$temp]}m[]\033[0m"
		fi	
	done
done
}
function draw()
{
local i j k flag temp te
flag=$1
if [[ $flag == 1 ]] ; then
for ((i = 0 ; i < 8 ; i = i + 2 ))
do
	(( j = i + 1 ))	
	(( temp = ytop + ${obox[$i]} + ${obox[8]} ))
	(( te = xleft + 2 * ${obox[$j]} + 2*${obox[9]} ))
	echo -ne "\033[${temp};${te}H\033[3${ocolor};4${ocolor}m[]\033[0m"
done
else
for ((i=0 ; i<8 ; i= i + 2 ))
do
	(( j = i + 1 ))	
	temp=$(( $ytop + ${obox[$i]} + ${obox[8]}))
	te=$(( $xleft + 2*(${obox[$j]} + ${obox[9]}) ))
	echo -ne "\033[${temp};${te}H  \033[0m"
done
fi
}
function drawnew()
{
local i j k temp te flag
flag=$1
if (( $flag == 1 )); then
for ((i = 0 ; i < 8 ; i = i + 2 ))
do
	(( j = i + 1 ))	
	(( temp = ytop + ${nbox[$i]} + ${nbox[8]} ))
	(( te = xleft + 2*width+ 2 * ${nbox[$j]} + 2*${nbox[9]} ))
	echo -ne "\033[${temp};${te}H\033[3${ncolor};4${ncolor}m[]\033[0m"
done
else
for ((i = 0 ; i < 8 ; i = i + 2 ))
do
	(( j = i + 1 ))	
	(( temp = ytop + ${nbox[$i]} + ${nbox[8]} ))
	(( te = xleft + 2*width+ 2 * ${nbox[$j]} + 2*${nbox[9]} ))
	echo -ne "\033[${temp};${te}H  \033[0m"
done
fi
}
display &
receive $!
