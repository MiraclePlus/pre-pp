/**
 * 模板对齐验证测试
 * 生成一个包含所有 7 种版式的测试 PPTX，用于视觉校验对齐是否正确
 *
 * 运行: NODE_PATH=./node_modules node test-layouts.js
 */

const { generateDeck } = require('./generate-deck');
const path = require('path');

const testSlides = [
  {
    layout: 'cover',
    data: {
      title: '能量橙子',
      subtitle: 'AI+情绪消费｜让每个人都能随时获得情绪价值',
      footer: '2026春季创业营 | 路演日',
    },
    bg: '#0A1628',
  },
  {
    layout: 'title-body',
    data: {
      pageNum: '2/12',
      heading: '市场痛点：情绪消费的巨大缺口',
      body: '中国情绪消费市场年规模超过2000亿元，但80%的产品停留在"物理层"——香薰、按摩椅、冥想App。真正能在5分钟内精准匹配用户当下情绪状态并提供个性化干预方案的产品，市场上几乎不存在。',
    },
  },
  {
    layout: 'title-bullets',
    data: {
      pageNum: '3/12',
      heading: '我们的解决方案',
      bullets: [
        'AI 实时情绪识别：语音+面部+生理信号融合',
        '个性化干预：10万+案例训练的推荐模型',
        '硬件+内容生态：手环采集 + App推送',
      ],
    },
  },
  {
    layout: 'split',
    data: {
      pageNum: '4/12',
      heading: '产品架构',
      left: '硬件端\n• 情绪感知手环\n• PPG + EDA 传感器\n• 7 天续航\n• 成本 ¥89',
      right: '软件端\n• AI 情绪分析引擎\n• 个性化内容推荐\n• 社交情绪地图\n• 企业员工版 SaaS',
    },
  },
  {
    layout: 'big-number',
    data: {
      pageNum: '5/12',
      heading: 'Traction',
      number: '50,000+',
      label: '月活跃用户（上线 4 个月）',
      note: '周增长率 18% | 次日留存 62% | 7 日留存 38%',
    },
  },
  {
    layout: 'three-column',
    data: {
      pageNum: '6/12',
      heading: '核心团队',
      col1: '👤\n张三\nCEO\n前字节跳动\n情绪AI负责人\n10年经验',
      col2: '👤\n李四\nCTO\n前阿里达摩院\n多模态算法\nNeurIPS发表',
      col3: '👤\n王五\nCPO\n前网易严选\n消费品设计\n爆款操盘手',
    },
  },
  {
    layout: 'end',
    data: {
      title: '谢谢！',
      contact: '创始人：张三\n微信：energyorange2026\n邮箱：ceo@energyorange.ai',
      booth: '展位 A-12',
    },
  },
];

async function main() {
  const outputPath = await generateDeck(testSlides, {
    outputDir: path.join(__dirname, '..', 'PP评估', 'decks'),
    filename: 'test-layout-alignment.pptx',
    theme: {
      bg: '#0A1628',
      text: '#FFFFFF',
      accent: '#FF6B35',
      muted: '#999999',
    },
  });
  console.log(`✅ 测试文件已生成: ${outputPath}`);
  console.log('请在 PowerPoint 或 WPS 中打开检查对齐效果');
}

main().catch(console.error);
