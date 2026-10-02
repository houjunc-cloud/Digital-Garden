传统Transformer：记 $k_i$ 为 $W_1$ 的第 $i$ 行，$v_i$ 为 $W_2$ 的第 $i$ 列，它们都是 $\mathbb R^d$ 里的向量。那么FFN是

$$\mathrm{FFN}(x)=W_2\,\sigma(W_1x)=\sum_{i=1}^{d_\text{ff}}\sigma(k_i^\top x)\,v_i.$$
$\sigma$ 是激活函数，$W_1$ 是 $4d \times d$ 维，$W_2$ 是 $d \times 4d$ 维数。选择4d只是convention，实际维数对损失函数影响不大。这个维数大了不会损失信息，并且会增强可学习性：

只看 FFN 输出的一个坐标，记 $m=d_\text{ff}$：

$$f(x)=\sum_{i=1}^{m}a_i\,\sigma(k_i^\top x).$$

参数 $k_i\in\mathbb R^d$、$a_i\in\mathbb R$ 取遍所有值，得到的函数全体记为 $\mathcal F_m$。这就是"宽度为 $m$ 的 FFN 能表示的函数类"。

"越宽越丰富"的准确含义有三层：

- **嵌套**：令 $a_{m+1}=0$ 可知 $\mathcal F_m\subset\mathcal F_{m+1}$。
- **万有逼近**：只要 $\sigma$ 不是多项式，$\bigcup_m\mathcal F_m$ 在紧集上的 $C(K)$ 中稠密（Leshno–Lin–Pinkus–Schocken 1993）。
- **定量版本**：Barron (1993) 证明，若 $f$ 满足 $\int|\omega|\,|\hat f(\omega)|\,d\omega<\infty$，则 $\mathcal F_m$ 中存在 $f_m$ 使 $\|f-f_m\|_{L^2(\mu)}\lesssim C_f/\sqrt m$，并且速率与维数 $d$ 无关。