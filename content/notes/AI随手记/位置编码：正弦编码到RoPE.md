tokenization以后要加上位置向量。

正弦编码：频率 $w_i := 10000^{-2i/d}$ ， 位置向量 $p_m:=(\sin mw_0,\cos mw_0, \sin mw_1, \cos mw_1, \cdots) \in \mathbb R^d$

为啥这么定义：
1. （平移不变性）$p_{m+k} = T_k p_m$，于是$<q_n,>$

