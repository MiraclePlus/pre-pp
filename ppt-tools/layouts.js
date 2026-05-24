/**
 * 路演 PPT 约束模板系统
 *
 * 设计原则：
 * - 画布: 10in x 5.625in (16:9, 720x405pt)
 * - 安全区: 上方 75% 区域放内容 (y ≤ 4.22in)，底部 25% 完全留白
 * - 最小字号: 32pt (正文)，标题 48-60pt
 * - 左右边距: 0.8in
 * - 所有坐标经路演厅实测校准
 */

const CANVAS = { w: 10, h: 5.625 };
const MARGIN = { left: 0.8, right: 0.8, top: 0.4, bottom: 1.69 }; // bottom = 30% of 5.625
const CONTENT_AREA = {
  x: MARGIN.left,
  y: MARGIN.top,
  w: CANVAS.w - MARGIN.left - MARGIN.right, // 8.4in
  h: CANVAS.h - MARGIN.top - MARGIN.bottom,  // 3.54in (安全高度, 底部30%留白)
};

// 字号规范 — 兼顾路演厅可读性与视觉美观
const FONT = {
  title: 44,        // 主标题（封面）
  subtitle: 28,     // 副标题
  heading: 30,      // 页面标题
  subheading: 24,   // 二级标题
  body: 22,         // 正文
  caption: 18,      // 说明文字
  pageNum: 12,      // 页码
};

/**
 * 模板 1: 封面 (Cover)
 * 居中大标题 + 一句话定位 + 创始人/公司名
 */
const COVER = {
  name: 'cover',
  zones: {
    title: { x: 1.2, y: 1.2, w: 7.6, h: 1.2, fontSize: 48, align: 'center', bold: true },
    subtitle: { x: 1.8, y: 2.6, w: 6.4, h: 0.6, fontSize: 24, align: 'center', color: 'AAAAAA' },
    footer: { x: 1.8, y: 3.4, w: 6.4, h: 0.4, fontSize: 16, align: 'center', color: '777777' },
  }
};

/**
 * 模板 2: 标题+正文 (Title-Body)
 * 顶部标题 + 大块正文区域，适合叙述性内容
 */
const TITLE_BODY = {
  name: 'title-body',
  zones: {
    pageNum: { x: 9.2, y: 0.2, w: 0.5, h: 0.3, fontSize: FONT.pageNum, align: 'right', color: '666666' },
    heading: { x: 0.8, y: 0.5, w: 7.5, h: 0.6, fontSize: FONT.heading, bold: true },
    body: { x: 0.8, y: 1.3, w: 8.4, h: 2.5, fontSize: FONT.body, valign: 'top', lineSpacing: 1.6 },
  }
};

/**
 * 模板 3: 标题+要点列表 (Title-Bullets)
 * 顶部标题 + 3-4 个要点，每行前有圆点
 */
const TITLE_BULLETS = {
  name: 'title-bullets',
  zones: {
    pageNum: { x: 9.2, y: 0.2, w: 0.5, h: 0.3, fontSize: FONT.pageNum, align: 'right', color: '666666' },
    heading: { x: 0.8, y: 0.5, w: 7.5, h: 0.6, fontSize: FONT.heading, bold: true },
    bullets: { x: 0.8, y: 1.3, w: 8.4, h: 2.6, fontSize: FONT.body, valign: 'top', bullet: true, lineSpacing: 1.8 },
  }
};

/**
 * 模板 4: 左右分栏 (Split)
 * 左侧文字 + 右侧图片/数据，或左右对称内容
 */
const SPLIT = {
  name: 'split',
  zones: {
    pageNum: { x: 9.2, y: 0.2, w: 0.5, h: 0.3, fontSize: FONT.pageNum, align: 'right', color: '666666' },
    heading: { x: 0.8, y: 0.5, w: 7.5, h: 0.6, fontSize: FONT.heading, bold: true },
    left: { x: 0.8, y: 1.3, w: 4.0, h: 2.6, fontSize: FONT.body, valign: 'top' },
    right: { x: 5.2, y: 1.3, w: 4.0, h: 2.6, fontSize: FONT.body, valign: 'top' },
  }
};

/**
 * 模板 5: 三列 (Three-Column)
 * 适合团队介绍、3 个核心优势、3 个产品特性
 */
const THREE_COLUMN = {
  name: 'three-column',
  zones: {
    pageNum: { x: 9.2, y: 0.2, w: 0.5, h: 0.3, fontSize: FONT.pageNum, align: 'right', color: '666666' },
    heading: { x: 0.8, y: 0.5, w: 7.5, h: 0.6, fontSize: FONT.heading, bold: true },
    col1: { x: 0.8, y: 1.3, w: 2.6, h: 2.6, fontSize: FONT.caption, valign: 'top', align: 'center' },
    col2: { x: 3.7, y: 1.3, w: 2.6, h: 2.6, fontSize: FONT.caption, valign: 'top', align: 'center' },
    col3: { x: 6.6, y: 1.3, w: 2.6, h: 2.6, fontSize: FONT.caption, valign: 'top', align: 'center' },
  }
};

/**
 * 模板 6: 大数据 (Big-Number)
 * 一个核心数据 + 补充说明，视觉冲击力最强
 */
const BIG_NUMBER = {
  name: 'big-number',
  zones: {
    pageNum: { x: 9.2, y: 0.2, w: 0.5, h: 0.3, fontSize: FONT.pageNum, align: 'right', color: '666666' },
    heading: { x: 0.8, y: 0.5, w: 7.5, h: 0.6, fontSize: FONT.heading, bold: true },
    number: { x: 0.8, y: 1.4, w: 8.4, h: 1.2, fontSize: 56, align: 'center', bold: true, color: 'accent' },
    label: { x: 0.8, y: 2.8, w: 8.4, h: 0.5, fontSize: FONT.body, align: 'center', color: '888888' },
    note: { x: 0.8, y: 3.4, w: 8.4, h: 0.4, fontSize: FONT.caption, align: 'center', color: '666666' },
  }
};

/**
 * 模板 7: 结尾页 (End)
 * 感谢/联系方式 + 二维码在右上角
 */
const END = {
  name: 'end',
  zones: {
    title: { x: 0.8, y: 0.6, w: 6.5, h: 0.9, fontSize: 48, bold: true },
    contact: { x: 0.8, y: 1.7, w: 6.5, h: 1.2, fontSize: FONT.body, valign: 'top', lineSpacing: 1.4 },
    booth: { x: 0.8, y: 3.1, w: 3.0, h: 0.6, fontSize: 36, bold: true, color: 'accent' },
    qrcode: { x: 8.0, y: 0.4, w: 1.3, h: 1.3, type: 'image' }, // 右上角，不与title重叠
  }
};

const ALL_LAYOUTS = {
  cover: COVER,
  'title-body': TITLE_BODY,
  'title-bullets': TITLE_BULLETS,
  split: SPLIT,
  'three-column': THREE_COLUMN,
  'big-number': BIG_NUMBER,
  end: END,
};

module.exports = {
  CANVAS,
  MARGIN,
  CONTENT_AREA,
  FONT,
  ALL_LAYOUTS,
  COVER,
  TITLE_BODY,
  TITLE_BULLETS,
  SPLIT,
  THREE_COLUMN,
  BIG_NUMBER,
  END,
};
