cd /home/data/sym/data/second
dir=/home/data/sym/data/second
# cleandata in /home/data/sym/data/second/cleandata
# fastqc
for i in 'ls rawdata/SP*'
do
fastqc -o ./qcreport -t 100 -q ${i}
done
#trimmomatic去接头
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-A1_1.fq.gz rawdata/SP-A1_2.fq.gz -baseout SP_A1.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51 
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-A2_1.fq.gz rawdata/SP-A2_2.fq.gz -baseout SP_A2.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-A3_1.fq.gz rawdata/SP-A3_2.fq.gz -baseout SP_A3.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-B1_1.fq.gz rawdata/SP-B1_2.fq.gz -baseout SP_B1.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-B2_1.fq.gz rawdata/SP-B2_2.fq.gz -baseout SP_B2.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-B3_1.fq.gz rawdata/SP-B3_2.fq.gz -baseout SP_B3.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-C1_1.fq.gz rawdata/SP-C1_2.fq.gz -baseout SP_C1.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-C2_1.fq.gz rawdata/SP-C2_2.fq.gz -baseout SP_C2.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51
java -jar /home/data/sym/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 rawdata/SP-C3_1.fq.gz rawdata/SP-C3_2.fq.gz -baseout SP_C3.fastq.gz ILLUMINACLIP:my_PE.fa:2:40:15:8:true SLIDINGWINDOW:4:20 MINLEN:51
#fastqc
for i in `ls SP*`
do
fastqc ${i} -o qcout/secqc/
done
mkdir cleandata
mv SP* cleandata
#合并
mkdir all
cat cleandata/SP_A?_1P.fastq.gz >> SP_A_1P.fastq.gz
cat cleandata/SP_A?_2P.fastq.gz >> SP_A_2P.fastq.gz
cat cleandata/SP_B?_1P.fastq.gz >> SP_B_1P.fastq.gz
cat cleandata/SP_B?_2P.fastq.gz >> SP_B_2P.fastq.gz
cat cleandata/SP_C?_1P.fastq.gz >> SP_C_1P.fastq.gz
cat cleandata/SP_C?_2P.fastq.gz >> SP_C_2P.fastq.gz
#megahit 分地点混拼
time megahit -t 100 -m 0.95 -1 cleandata/SP_A1_1P.fastq.gz,cleandata/SP_A2_1P.fastq.gz,cleandata/SP_A3_1P.fastq.gz -2  cleandata/SP_A1_2P.fastq.gz,cleandata/SP_A2_2P.fastq.gz,cleandata/SP_A3_2P.fastq.gz -o  megahit.mix/SPA_Contig
time megahit -t 120 -m 0.95 -1 cleandata/SP_B1_1P.fastq.gz,cleandata/SP_B2_1P.fastq.gz,cleandata/SP_B3_1P.fastq.gz -2  cleandata/SP_B1_2P.fastq.gz,cleandata/SP_B2_2P.fastq.gz,cleandata/SP_B3_2P.fastq.gz -o  megahit.mix/SPB_Contig
time megahit -t 120 -m 0.95 -1 cleandata/SP_C1_1P.fastq.gz,cleandata/SP_C2_1P.fastq.gz,cleandata/SP_C3_1P.fastq.gz -2  cleandata/SP_C1_2P.fastq.gz,cleandata/SP_C2_2P.fastq.gz,cleandata/SP_C3_2P.fastq.gz -o  megahit.mix/SPC_Contig
#megahit 单拼
time megahit -t 100 -m 0.95 -1 cleandata/SP_A1_1P.fastq.gz -2  cleandata/SP_A1_2P.fastq.gz -o  megahit.single/SPA1_Contig
time megahit -t 120 -m 0.95 -1 cleandata/SP_B1_1P.fastq.gz -2  cleandata/SP_B1_2P.fastq.gz -o  megahit.single/SPB1_Contig
time megahit -t 120 -m 0.95 -1 cleandata/SP_C1_1P.fastq.gz -2  cleandata/SP_C1_2P.fastq.gz -o  megahit.single/SPC1_Contig
time megahit -t 100 -m 0.95 -1 cleandata/SP_A2_1P.fastq.gz -2  cleandata/SP_A2_2P.fastq.gz -o  megahit.single/SPA2_Contig
time megahit -t 120 -m 0.95 -1 cleandata/SP_B2_1P.fastq.gz -2  cleandata/SP_B2_2P.fastq.gz -o  megahit.single/SPB2_Contig
time megahit -t 120 -m 0.95 -1 cleandata/SP_C2_1P.fastq.gz -2  cleandata/SP_C2_2P.fastq.gz -o  megahit.single/SPC2_Contig
time megahit -t 100 -m 0.95 -1 cleandata/SP_A3_1P.fastq.gz -2  cleandata/SP_A3_2P.fastq.gz -o  megahit.single/SPA3_Contig
time megahit -t 120 -m 0.95 -1 cleandata/SP_B3_1P.fastq.gz -2  cleandata/SP_B3_2P.fastq.gz -o  megahit.single/SPB3_Contig
time megahit -t 120 -m 0.95 -1 cleandata/SP_C3_1P.fastq.gz -2  cleandata/SP_C3_2P.fastq.gz -o  megahit.single/SPC3_Contig
#reassembly
for i in `ls ${dir}/megahit.mix/`
do
cd ${dir}/megahit.mix/${i}
2bwt-builder final.contigs.fa
done
cd ${dir}
soap -p 100 -r 2 -m 200 -x 400 -M 4 -a cleandata/all/SP_A_1P.fastq.gz -b cleandata/all/SP_A_2P.fastq.gz -D ${dir}/megahit.mix/SPA_Contig/final.contigs.fa.index -o soap/SPA_PE.soap -2 soap/SPA_SE.soap -u soap/SPA_UN.fasta
soap -p 100 -r 2 -m 200 -x 400 -M 4 -a cleandata/all/SP_B_1P.fastq.gz -b cleandata/all/SP_B_2P.fastq.gz -D ${dir}/megahit.mix/SPB_Contig/final.contigs.fa.index -o soap/SPB_PE.soap -2 soap/SPB_SE.soap -u soap/SPB_UN.fasta
soap -p 100 -r 2 -m 200 -x 400 -M 4 -a cleandata/all/SP_C_1P.fastq.gz -b cleandata/all/SP_C_2P.fastq.gz -D ${dir}/megahit.mix/SPC_Contig/final.contigs.fa.index -o soap/SPC_PE.soap -2 soap/SPC_SE.soap -u soap/SPC_UN.fasta
cd soap
for i in `ls ???_UN.fasta`
do
less ${i} |grep "1$" |sed 's/>//'> ${i}.1.id
less ${i} |grep "2$" |sed 's/>//'> ${i}.2.id
seqtk subseq ${i} ${i}.1.id  > ${i}.1.fa
seqtk subse
${i} ${i}.2.id  > ${i}.2.fa
done
cd ${dir}
time megahit -t 100 -m 0.95 -1 soap/SPA_UN.fasta.1.fa,soap/SPB_UN.fasta.1.fa,soap/SPC_UN.fasta.1.fa -2 soap/SPA_UN.fasta.2.fa,soap/SPB_UN.fasta.2.fa,soap/SPC_UN.fasta.2.fa  -o reassembly
#metaProdigal基因预测
mkdir contig
cat megahit.mix/*/final.contigs.fa reassembly/final.contigs.fa >contig/all.contig.fa
mkdir orf
time prodigal -i contig/all.contig.fa -d orf/SP_orf.fa -o orf/SP_orf.gff -p meta -f gff 
##查看预测到的基因数量
grep -c '>' orf/SP_orf.fa 
##查看预测到完整基因组的数量
grep -c 'partial=00' orf/SP_orf.fa
#选择完整的基因组，这里选择的是成环的基因组
grep 'partial=00' orf/SP_orf.fa|cut -f1 -d ' '|sed 's/>//' > orf/full_length.id
seqkit grep -f orf/full_length.id orf/SP_orf.fa > orf/full_length.fa
#去冗余并翻译
time cd-hit-est -i orf/SP_orf.fa -o ./unigene.fa -aS 0.9 -c 0.95 -G 0 -g 0 -T 0 -M 0
# 统计非冗余基因数量，单次拼接结果数量下降不大，多批拼接冗余度高
#grep -c '>' unigene.fa
#14276007
#grep -c '>' orf/SP_orf.fa
#15981437
#下降不大
#翻译核酸为对应蛋白序列，emboss
transeq -sequence ./unigene.fa -outseq ./uniprotein.fa -trim Y
# 序列名自动添加了_1，为与核酸对应要去除
sed -i 's/_1 / /' ./uniprotein.fa
#改序列名称
cat unigene.fa |  seqkit replace -p ".+" -r "seq_{nr}" --nr-width 8 >> rename_unigene.fa
#Gene quantitfy
#索引
time /home/data/sym/software/salmon-1.6.0_linux_x86_64/bin/salmon index \
        -t /home/data/sym/data/second/rename_unigene.fa \
        -i /home/data/sym/data/second/temp/salmon/index
#定量，l文库类型自动选择，p线程，--meta宏基因组模式, 9个任务并行9个样
# 注意parallel中待并行的命令必须是双引号，内部变量需要使用原始绝对路径
time parallel -j 9 \
        "/home/data/sym/software/salmon-1.6.0_linux_x86_64/bin/salmon quant \
        -i /home/data/sym/data/second/temp/salmon/index -l A  --meta \
        -1 /home/data/sym/data/second/cleandata/{1}_1P.fastq.gz \
        -2 /home/data/sym/data/second/cleandata/{1}_2P.fastq.gz \
        -o /home/data/sym/data/second/temp/salmon/{1}.quant" \
        ::: `cat /home/data/sym/data/second/name2`
# 合并
mkdir -p result/salmon
/home/data/sym/software/salmon-1.6.0_linux_x86_64/bin/salmon quantmerge \
    --quants /home/data/sym/data/second/temp/salmon/*.quant \
    -o /home/data/sym/data/second/salmon/gene.TPM
/home/data/sym/software/salmon-1.6.0_linux_x86_64/bin/salmon quantmerge \
    --quants /home/data/sym/data/second/temp/salmon/*.quant \
    --column NumReads -o /home/data/sym/data/second/salmon/gene.count
sed -i '1 s/.quant//g' salmon/gene.*
#得到的gene.count就是相对丰度


#接下来需要进行注释，根据我目前的研究思路，首先做抗生素抗性基因注释，然后物种注释
#抗性基因用CARD的rgi方式
#rgi安装参考github：https://github.com/arpcard/rgi
conda activate rgi
rgi main --input_sequence /home/data/sym/data/second/unigene.fa \
  --output_file /home/data/sym/data/second/ARGs --input_type contig --local \
  --alignment_tool DIAMOND --num_threads 80 --split_prodigal_jobs --clean
#目前rgi不太能够得到结果，所以目前改用diamond或者blast比对
#比对结束以后使用阈值筛选，得到每组的抗生素抗性基因的情况，目前还无法得到结果
#做完抗生素抗性基因的注释以后，尝试使用metachip寻找基因的HGT事件，但是还是要阅读完综述“”
