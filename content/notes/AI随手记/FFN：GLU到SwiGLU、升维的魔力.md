传统Transformer：记 $k_i$ 为 $W_1$ 的第 $i$ 行，$v_i$ 为 $W_2$ 的第 $i$ 列，它们都是 $\mathbb R^d$ 里的向量。那么FFN是

$$\mathrm{FFN}(x)=W_2\,\sigma(W_1x)=\sum_{i=1}^{d_\text{ff}}\sigma(k_i^\top x)\,v_i.$$
$\sigma$ 是激活函数，$W_1$ 是 $4d \times d$ 维，$W_2$ 是 $d \times 4d$ 维数。选择4d只是convention，实际维数对损失函数影响不大。

尽管如此，升维有诸多好处：
1. 维数大了至少不会损失信息
2. 会增强可区分度或者说语义表达能力- **低维的困境（以 XOR 异或问题为例）**：  
    假设你在二维平面上有四个点，\(A(0,0)\) 和 \(B(1,1)\) 是第一类，\(C(1,0)\) 和 \(D(0,1)\) 是第二类。这两类点交错在一起，你在纸上**绝对画不出来一条直线**把它们完美分开。这就是典型的线性不可分。
	**升维的魔力**：  
    如果我们引入一个新维度（比如把每个点映射到三维空间，第三维的值是 \(x \times y\)）。此时：
    
    - \(A(0,0) \rightarrow (0,0,0)\)
    - \(B(1,1) \rightarrow (1,1,1)\)
    - \(C(1,0) \rightarrow (1,0,0)\)
    - \(D(0,1) \rightarrow (0,1,0)\)
    
    现在你在三维空间里看，切一刀（切面），就能完美把 A、B 和 C、D 分开了！**这就是升维的意义：把复杂、扭曲的低维分布，拉直变成高维的线性分布。**
3. 理论上会增强可学习性，因为你的特征函数越来越丰富：
    只看 FFN 输出的一个坐标，记 $m=d_\text{ff}$：
	$$f(x)=\sum_{i=1}^{m}a_i\,\sigma(k_i^\top x).$$
	参数 $k_i\in\mathbb R^d$、$a_i\in\mathbb R$ 取遍所有值，得到的函数全体记为 $\mathcal F_m$。这就是"宽度为 $m$ 的 FFN 能表示的函数类"。
	
	"越宽越丰富"的准确含义有三层：
	
	- **嵌套**：令 $a_{m+1}=0$ 可知 $\mathcal F_m\subset\mathcal F_{m+1}$。
	- **万有逼近**：只要 $\sigma$ 不是多项式，$\bigcup_m\mathcal F_m$ 在紧集上的 $C(K)$ 中稠密（Leshno–Lin–Pinkus–Schocken 1993）。
	- **定量版本**：Barron (1993) 证明，若 $f$ 满足 $\int|\omega|\,|\hat f(\omega)|\,d\omega<\infty$，则 $\mathcal F_m$ 中存在 $f_m$ 使 $\|f-f_m\|_{L^2(\mu)}\lesssim C_f/\sqrt m$，并且速率与维数 $d$ 无关。
4. 尽管没有好的解释，实验结果表明 $\sigma(W_1x)$ 会变成稀疏向量（大片0），则可以用稀疏编码的过完备字典解释。
	给定字典 $D=[d_1,\dots,d_m]\in\mathbb R^{d\times m}$，其中 $m>d$（过完备），把信号写成
	$$x\approx Ds=\sum_{i=1}^m s_i\,d_i,\qquad s\ \text{稀疏（大部分 }s_i=0\text{）}.$$
	
	因为 $m>d$，满足 $x=Ds$ 的 $s$ 有无穷多个。稀疏编码就是在其中挑非零项最少的那个。这里把 $D$ 理解成一组基，$s$ 就是去算基的系数。FFN就是把一个乱七八糟的空间先抽离开（升维），然后转移到另一个整齐规划的空间

Rmk：基于4的稀疏特性，可以去预测哪些地方出现稀疏，从而简化计算。

**GLU**（gated linear unit，Dauphin et al. 2017）的形式是 $(Wx)\odot\mathrm{sigmoid}(Vx)$：一路提供内容，一路充当开关，$\odot$ 是Hadamard积（逐个元素相乘）。相当于筛选Shazeer (2020) 把这个结构的升级版本放进 FFN 的第一层：

$$\mathrm{FFN}_{\text{SwiGLU}}(x)=W_2\big(\mathrm{Swish}(W_1x)\odot W_3x\big),\qquad \mathrm{Swish}(z)=z\cdot\mathrm{sigmoid}(z).$$

Swish 也叫 SiLU，名字 SwiGLU 就是 Swish + GLU。门换成别的激活函数，就得到这一族的其他成员：sigmoid 对应原始 GLU，ReLU 对应 ReGLU，GELU 对应 GEGLU，恒等映射对应 Bilinear。

**参数对齐。**SwiGLU 多了一个矩阵 $W_3$。为了和基线保持同样的参数量和 FLOPs，隐藏维度从 $4d$ 缩到 $\tfrac83 d$：

$$3\cdot d\cdot\tfrac83 d=8d^2=2\cdot d\cdot 4d.$$