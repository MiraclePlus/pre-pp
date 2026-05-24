/**
 * 路演 PPTX 生成引擎（约束模板版）
 *
 * 用法:
 *   const { generateDeck } = require('./generate-deck');
 *   generateDeck(slides, options).then(path => console.log(path));
 *
 * slides 格式:
 *   [{ layout: 'cover', data: { title: '...', subtitle: '...' }, bg: '#0A1628' }, ...]
 */

const PptxGenJS = require('pptxgenjs');
const path = require('path');
const { ALL_LAYOUTS, CANVAS, FONT } = require('./layouts');

const DEFAULT_OPTIONS = {
  outputDir: path.join(__dirname, '..', 'PP评估', 'decks'),
  filename: 'deck.pptx',
  theme: {
    bg: '#0A1628',
    text: '#FFFFFF',
    accent: '#3B82F6',
    muted: '#999999',
  },
  font: 'Microsoft YaHei',
};

/**
 * 生成 PPTX
 * @param {Array} slides - 幻灯片数据数组
 * @param {Object} opts - 配置选项
 * @returns {Promise<string>} 输出文件路径
 */
async function generateDeck(slides, opts = {}) {
  const options = { ...DEFAULT_OPTIONS, ...opts };
  const pptx = new PptxGenJS();

  pptx.defineLayout({ name: 'DEMO_DAY', width: CANVAS.w, height: CANVAS.h });
  pptx.layout = 'DEMO_DAY';

  for (const slideData of slides) {
    const layout = ALL_LAYOUTS[slideData.layout];
    if (!layout) {
      console.warn(`Unknown layout: ${slideData.layout}, skipping`);
      continue;
    }
    renderSlide(pptx, slideData, layout, options);
  }

  const outputPath = path.join(options.outputDir, options.filename);
  await pptx.writeFile({ fileName: outputPath });
  return outputPath;
}

function renderSlide(pptx, slideData, layout, options) {
  const bg = slideData.bg || options.theme.bg;
  const slide = pptx.addSlide();
  slide.background = { color: bg.replace('#', '') };

  const { data = {} } = slideData;
  const zones = layout.zones;

  for (const [zoneName, zone] of Object.entries(zones)) {
    const content = data[zoneName];
    if (content === undefined || content === null || content === '') continue;

    if (zone.type === 'image') {
      addImage(slide, zone, content, options);
    } else {
      addText(slide, zone, zoneName, content, slideData, options);
    }
  }
}

function addText(slide, zone, zoneName, content, slideData, options) {
  const theme = { ...DEFAULT_OPTIONS.theme, ...(slideData.theme || {}) };

  let textColor = zone.color || theme.text;
  if (textColor === 'accent') textColor = theme.accent;
  textColor = textColor.replace('#', '');

  const textOpts = {
    x: zone.x,
    y: zone.y,
    w: zone.w,
    h: zone.h,
    fontSize: zone.fontSize || FONT.body,
    fontFace: options.font,
    color: textColor,
    bold: zone.bold || false,
    align: zone.align || 'left',
    valign: zone.valign || 'middle',
    wrap: true,
    shrinkText: true, // 关键：文字超出时自动缩小而非溢出
    margin: [0.05, 0.1, 0.05, 0.1], // 小内边距防止贴边
  };

  if (zone.lineSpacing) {
    textOpts.lineSpacingMultiple = zone.lineSpacing;
  }

  if (zone.bullet && Array.isArray(content)) {
    const textItems = content.map((item, i) => ({
      text: item,
      options: {
        fontSize: zone.fontSize || FONT.body,
        color: textColor,
        bullet: { code: '2022' }, // bullet char •
        breakLine: i < content.length - 1,
      }
    }));
    slide.addText(textItems, textOpts);
  } else if (Array.isArray(content)) {
    // 多段文字
    const textItems = content.map((item, i) => {
      if (typeof item === 'string') {
        return { text: item, options: { breakLine: i < content.length - 1, fontSize: zone.fontSize, color: textColor } };
      }
      // item can be { text, fontSize, color, bold }
      return {
        text: item.text,
        options: {
          fontSize: item.fontSize || zone.fontSize,
          color: (item.color || textColor).replace('#', ''),
          bold: item.bold || zone.bold || false,
          breakLine: i < content.length - 1,
        }
      };
    });
    slide.addText(textItems, textOpts);
  } else {
    slide.addText(String(content), textOpts);
  }
}

function addImage(slide, zone, imagePath, options) {
  const imgOpts = {
    x: zone.x,
    y: zone.y,
    w: zone.w,
    h: zone.h,
    sizing: { type: 'contain', w: zone.w, h: zone.h },
  };

  if (imagePath.startsWith('http')) {
    imgOpts.path = imagePath;
  } else {
    imgOpts.path = imagePath;
  }

  try {
    slide.addImage(imgOpts);
  } catch (e) {
    // 图片加载失败时放一个占位框
    slide.addShape('rect', {
      x: zone.x, y: zone.y, w: zone.w, h: zone.h,
      fill: { color: '333333' },
      line: { color: '555555', width: 1 },
    });
  }
}

module.exports = { generateDeck, ALL_LAYOUTS, CANVAS, FONT };
