# CZ Skill 蒸馏方法论 + 证据索引

> 本文件描述 `aicz-skill` 是如何从 89 个原始素材压缩到一个可分发 SKILL.md 的。
> 调研截止日期：2026-05-04。

---

## 蒸馏标准（产品层硬约束）

CZ Persona 必须先通过 **5 条立得住硬标准**才能 publish：

| 标准 | 是否通过 | 证据 |
|---|---|---|
| 表达稳定（多轮不漂移） | ✓ | 73 问 AMA / X 8000+ 推文 / 监狱中手写自传，言语风格高度一致 |
| 立场明确 | ✓ | 用户优先 / 长期主义 / 反 meme 投机 / 国家边界论 等都是 hard stance |
| 会反问 | ✓ | "你想要什么？" 是默认开场；"你为啥问这个？" 是常用追问 |
| 会拒绝 | ✓ | 整本《CZ 的原則》核心就是说"不"；SKILL.md 拒绝模板 8 类提供运行时实现 |
| 信息不完备 | ✓ | "我中文也差不多停留在小学水平" / "我不熟悉营销，要么授权要么问专家" / 不评价同行 |

**五条全过 → 蒸馏成立。**

---

## 来源权重排序

按对 SKILL.md 内容的贡献度从高到低：

1. **《Freedom of Money》自传**（监狱中手写初稿，繁体中文版 519KB）
   - 第一人称、最坦诚的来源
   - 附录《CZ 的原則》72 条 = 最高权威**自陈纲领**
   - SKILL.md 中 9 个心智模型有 7 个直接来自这本书

2. **《CZ 的原則》72 条**（自传附录）
   - 单独权重最高的引用源
   - SKILL.md 中所有"决策启发式"和"内在张力"的根证据

3. **CZ X 8000+ 推文**（cz_binance）
   - 表达 DNA 的高密度示例库
   - 5 个标志性表达模板全部从这里提炼

4. **2026 当下立场访谈**
   - CNBC 达沃斯（2026-01）— 当下立场基线
   - CoinDesk FUD 反击（2026-02）— 危机响应
   - 自传英文版报道（2026-04）— 出版后语境

5. **法律 / 监管文件**
   - DOJ 认罪声明 / SEC 起诉 / Wikipedia / 赦免分析
   - 决定 SKILL.md 中"红线"和"诚实边界"的具体内容

6. **何一序言 + 共同创办人视角**
   - 公开/私下行为差异的唯一可验证来源
   - "他總是問孩子們好不好" / "亞馬遜平價衣服騎自行車開會" 等私下视角

---

## 已覆盖维度（PersonaSnapshot 9 维）

| 维度 | 文件位置 | 来源 |
|---|---|---|
| **identity** | SKILL.md "身份卡" + 时间线 | 自传前言 + Wikipedia + 何一序言 |
| **coreBeliefs** | SKILL.md "价值观与反模式 - 我追求的" | 《CZ 的原則》#1, #4, #6, #16, #15 |
| **boundaries** | SKILL.md "拒绝模板" + "红线" | 《CZ 的原則》#42 + DOJ 协议 |
| **languageStyle** | SKILL.md "表达 DNA" | X 推文语料统计 + 自传第二语言自陈 |
| **expressionDNA** | SKILL.md "5 个标志性模板" | X 推文模式抽取（"4" / "gm" / Save the tweet） |
| **mentalModels** | SKILL.md "9 个核心心智模型" | 《CZ 的原則》全卷 + 决策案例 |
| **decisionHeuristics** | SKILL.md "11 条决策启发式" | 自传 + 黑客事件 + 监管 + 招聘案例 |
| **antiPatterns** | SKILL.md "我拒绝的（绝不做）" | `cz-behavioral-patterns.md` 11 条反模式 |
| **innerTensions** | SKILL.md "我自己也没想清楚的" | `cz-behavioral-patterns.md` 8 对张力 |

---

## 排除原则（不进 SKILL）

按 Persona.market 内部规范，以下来源**不参与**蒸馏：

- ❌ 知乎答案 / 微信公众号转述 / 百度百科
- ❌ 训练语料里的二手概括
- ❌ 翻译过的二手版本（除非原文不可得）
- ❌ AI 生成的 CZ 模仿文（防 SKILL 自污染）

---

## 三维验证

参照 Persona.market 建模管线（apps/server/src/modules/cognitive-extraction）的 cross-domain / generative / exclusivity 验证：

### Cross-Domain（跨场景一致性）
将每个心智模型在不同领域的应用做交叉对照：

| 模型 | 加密场景 | 时间管理场景 | 个人决策场景 | 一致性 |
|---|---|---|---|---|
| 短期赢抹杀长期赢 | 反对 meme 投机 | 拒绝快赢的会议 | 卖房全仓不卖 | ✓ |
| 时间唯一稀缺 | 默认 5 分钟会 | 戒电视 / 高尔夫 | 不收集贵重物品 | ✓ |
| 国家边界是人画的 | 全球分布式公司 | 跨时区团队 | "几年搬一次家" | ✓ |

### Generative（生成新观点能力）
SKILL 必须能对**调研截止后**才发生的事件给出 CZ 风格判断。测试用例：

- "Trump 要不要发币" → 用"不评价同行 / 不评价政治 / 第一性原理看是什么本质"组合
- "AI Agent 会不会颠覆 BNB Chain" → "8 billion 用 crypto" + "more building" + 不预测短期
- "Vitalik 最新 ETH roadmap" → "我尊重 Vitalik，技术问题问他不问我"

### Exclusivity（排他性）
SKILL 必须能区分 CZ 与其他加密大佬：

| 维度 | CZ | SBF | Vitalik | Sun Yuchen |
|---|---|---|---|---|
| 核心信念 | 保护用户 + 长期 | 期望值最大化 | 公共物品 | 注意力即流量 |
| 风格 | 短句 / "4" / 沉默 | 长 thread / 数学化 | 极长 / 技术化 | 数字轰炸 / 自夸 |
| 危机响应 | 主动认罪 + 直播 | 长篇辩护 | 沉默或论文 | 加倍碰瓷 |
| 投资风格 | 5 项标准 + DYOR | 不公开 | 公共品偏好 | 站台 + 上头条 |

CZ 的"短句 + 主动承担 + 不预测短期 + 不站台"组合**唯一**。

---

## 已知局限

1. **CZ 仍在世且持续输出**——SKILL 调研截止 2026-05-04，之后的推文 / 采访 / 事件不在内
2. **DOJ 协议红线是真红线**——SKILL 严格不能模拟"作为 Binance CEO 现在的运营决策"
3. **私下表达 vs 公开表达的差距**——除何一序言外，私下视角资料稀少；某些观点（对具体监管者 / 同行的真实态度）SKILL 推断不出
4. **2024 年监狱期间的内心活动**——只有自传第一人称回忆，无第二信源验证

---

## 后续更新流程

任何 SKILL 内容更新必须走：

```
新素材落到 references/research/ → 增量 distillation → 在 SKILL.md 对应章节标记证据出处 → 验证 5 条硬标准仍通过 → 提交
```

**禁止**：直接改 SKILL.md 不动 references/。这违反 Persona.market 的"补来源 → recompile"硬约束。

---

> 蒸馏由 [Persona.market](https://persona.market) 内部建模管线完成。
> 三维验证逻辑参考：apps/server/src/modules/cognitive-extraction
