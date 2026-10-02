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

$$\mathrm{FFN}_{\text{GLU}}=\big(\sigma(xW)\odot xV\big)W_2,\qquad \mathrm{FFN}_{\text{SwiGLU}}=\big(\mathrm{Swish}(xW)\odot xV\big)W_2.$$
### 先看 ReLU：它本来就是一个门

$$\mathrm{ReLU}(w^\top x)=\mathbf 1[w^\top x>0]\odot(w^\top x).$$

ReLU 单元其实也是"门 × 内容"，只是**门和内容用的是同一个方向 $w$**：它能做的只是"当 $w$ 方向的条件成立时，输出 $w$ 方向上的量"。

### GLU：把条件和内容分开

$$\sigma(v^\top x)\cdot(w^\top x)\ \approx\ \mathbf 1[v^\top x>0]\odot(w^\top x)\qquad(|v^\top x|\ \text{较大时}).$$

现在条件看 $v$，内容看 $w$，两者互不相干。这个单元的含义是：**当 $v$ 方向的条件成立时，把 $w$ 方向上的量传过去。举个只用来说明意思的例子：$v$ 检测"当前 token 是动词"，$w$ 读出"时态"，这个单元就只在动词上传递时态信息。ReLU 单元做不到这一点，因为它的"条件"和"报告的量"是同一件事。

### SwiGLU 改进了什么

$$\mathrm{Swish}(v^\top x)\cdot(w^\top x)\ \approx\ \mathbf 1[v^\top x>0]\cdot(v^\top x)(w^\top x).$$

对比如下：

> [!note] 
>
> |   | 在 $v^\top x>0$ 一侧 | 在 $v^\top x<0$ 一侧 | 门的取值范围 |
> |---|---|---|---|
> | GLU | $\approx w^\top x$（一次） | $\approx 0$ | $(0,1)$，有上界 |
> | SwiGLU | $\approx (v^\top x)(w^\top x)$（二次） | $\approx 0$ | 正向无上界 |

改进体现在两个方面。

**1. 门不再饱和。**$\sigma'(z)=\sigma(z)(1-\sigma(z))\le\tfrac14$，并且当 $|z|$ 变大时以指数速度趋于 0。所以一个门一旦完全打开或完全关闭，$v$ 几乎就收不到梯度，门停止学习。这和 2010 年前后 ReLU 取代 sigmoid 作为激活函数是同一个原因。Swish 在 $z\to+\infty$ 时导数趋于 1，打开的门可以继续学习。

**2. 门带有幅度。**sigmoid 门最大是 1，条件只能起"开或关"的作用。Swish 门的大小随 $v^\top x$ 线性增长，于是输出变成"条件成立的程度 × 内容"，这是两个特征的乘积，相当于一种软的"与"（AND）。所以第一条回答里说，SwiGLU 大致是"在半空间上打开的二次型"。