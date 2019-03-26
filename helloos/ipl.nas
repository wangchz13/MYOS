; hello-os
; TAB=4
CYLS	EQU		10				; 10个柱面

		ORG		0x7c00			; 如果没有这个伪指令，那标号编译时就从00H开始，而这不是程序实际被加载到内存中的位置，故会出错。

; 以下は標準的なFAT12フォーマットフロッピーディスクのための記述

		JMP		entry
		DB		0x90
		DB		"HELLOIPL"		; ブートセクタの名前を自由に書いてよい（8バイト）
		DW		512				; 1セクタの大きさ（512にしなければいけない）
		DB		1				; クラスタの大きさ（1セクタにしなければいけない）
		DW		1				; FATがどこから始まるか（普通は1セクタ目からにする）
		DB		2				; FATの個数（2にしなければいけない）
		DW		224				; ルートディレクトリ領域の大きさ（普通は224エントリにする）
		DW		2880			; このドライブの大きさ（2880セクタにしなければいけない）
		DB		0xf0			; メディアのタイプ（0xf0にしなければいけない）
		DW		9				; FAT領域の長さ（9セクタにしなければいけない）
		DW		18				; 1トラックにいくつのセクタがあるか（18にしなければいけない）
		DW		2				; ヘッドの数（2にしなければいけない）
		DD		0				; パーティションを使ってないのでここは必ず0
		DD		2880			; このドライブ大きさをもう一度書く
		DB		0,0,0x29		; よくわからないけどこの値にしておくといいらしい
		DD		0xffffffff		; たぶんボリュームシリアル番号
		DB		"HELLO-OS   "	; ディスクの名前（11バイト）
		DB		"FAT12   "		; フォーマットの名前（8バイト）
		RESB	18				; とりあえず18バイトあけておく

; プログラム本体

entry:
		MOV		AX,0			; 
		MOV		SS,AX			;栈段初始化
		MOV		SP,0x7c00		;
		MOV		DS,AX
	
		MOV 	AX, 0x0820
		MOV 	ES,AX
		MOV 	CH,0			; 柱面0
		MOV		DH,0			; 磁头0
		MOV		CL,2			; 扇区2
		
readloop:
		MOV 	SI,0
retry:	
		MOV		AH,0x02			; 读盘
		MOV		AL,1			; 1个扇区
		MOV		BX,0			
		MOV		DL,0X00			; A驱动器
		INT		0x13			; 调用磁盘BIOS
		JNC 	next
		ADD		SI,1
		CMP		SI,5
		JAE		error
		MOV		AH,0x00
		MOV		DL,0x00
		INT  	0x13			; 重置驱动器，复位磁盘状态
		JMP		retry

next:
		MOV		AX,ES
		ADD		AX,0x200
		MOV		ES,AX
		ADD		CL,1
		CMP		CL,18			; 读入18个扇区
		JBE		readloop
		MOV 	CL,1			; 扇区置1
		ADD		DH,1			; 换磁头
		CMP		DH,2
		JB  	readloop
		MOV		DH,0			; 0磁头
		ADD		CH,1			; 柱面加1
		CMP		CH,CYLS
		JB		readloop
fin:	
		HLT						; 何かあるまでCPUを停止させる
		JMP		fin	
error:	
		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1			; SIに1を足す
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 一文字表示ファンクション
		MOV		BX,14			; カラーコード
		INT		0x10			; ビデオBIOS呼び出し
		JMP		putloop
			; 無限ループ

msg:
		DB		0x0a, 0x0a		; 改行を2つ
		DB		"load error"
		DB		0x0a			; 改行
		DB		0

		RESB	0x7dfe-$		; 0x7dfe - 0x7c00 = 510字节

		DB		0x55, 0xaa