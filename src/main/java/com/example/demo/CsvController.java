package com.example.demo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CsvController {
    
    private int totalStore = 0;
    private double sumAllStore = 0;
    private double avgAllStore = 0;
    private double maxStore = 0;
    private double minStore = 0;
    private double corRPStore = 0;
    private double corRRStore = 0;
    private double corPPStore = 0;
    private double avgRatingStore = 0;
    private double avgPriceStore = 0;
    private double medianRatingStore = 0;
    private double medianPriceStore = 0;

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @PostMapping("/upload")
    public String uploadCsv(@RequestParam("file") MultipartFile file, Model model, HttpSession session) {
        try {
            // 验证文件
            if (file.isEmpty()) {
                model.addAttribute("msg", "请选择文件！");
                return "index";
            }
            
            String originalFilename = file.getOriginalFilename();
            if (originalFilename == null || !originalFilename.toLowerCase().endsWith(".csv")) {
                model.addAttribute("msg", "文件格式错误！请上传CSV格式文件。");
                return "index";
            }
            
            // 检查文件大小（限制10MB）
            if (file.getSize() > 10 * 1024 * 1024) {
                model.addAttribute("msg", "文件太大！请上传小于10MB的文件。");
                return "index";
            }
            
            BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream(), "UTF-8"));
            String headerLine = br.readLine();
            
            // 验证CSV头部
            if (headerLine == null || headerLine.trim().isEmpty()) {
                model.addAttribute("msg", "CSV文件为空！请检查文件内容。");
                br.close();
                return "index";
            }
            
            List<Double> ratingList = new ArrayList<>();
            List<Double> peopleList = new ArrayList<>();
            List<Double> priceList = new ArrayList<>();
            String line;
            int skipBadLine = 0;
            int totalLines = 0;

            while ((line = br.readLine()) != null) {
                totalLines++;
                String[] arr = line.split(",");
                
                // 跳过空行
                if (line.trim().isEmpty()) {
                    continue;
                }
                
                if (arr.length < 7) {
                    skipBadLine++;
                    if (skipBadLine <= 3) { // 只记录前3个错误
                        System.err.println("跳过第" + totalLines + "行：列数不足（" + arr.length + "列，需要至少7列）");
                    }
                    continue;
                }
                
                try {
                    double rating = Double.parseDouble(arr[4].trim());
                    double people = Double.parseDouble(arr[5].trim());
                    double price = Double.parseDouble(arr[6].trim());
                    
                    // 数据验证
                    if (rating < 0 || rating > 5) {
                        System.err.println("第" + totalLines + "行评分异常：" + rating);
                        continue;
                    }
                    if (people < 0) {
                        System.err.println("第" + totalLines + "行人数异常：" + people);
                        continue;
                    }
                    if (price < 0) {
                        System.err.println("第" + totalLines + "行价格异常：" + price);
                        continue;
                    }
                    
                    ratingList.add(rating);
                    peopleList.add(people);
                    priceList.add(price);
                } catch (NumberFormatException e) {
                    skipBadLine++;
                    if (skipBadLine <= 3) {
                        System.err.println("第" + totalLines + "行数据格式错误：" + e.getMessage());
                    }
                }
            }
            br.close();
            
            // 验证数据
            if (ratingList.isEmpty()) {
                model.addAttribute("msg", "没有找到有效数据！请检查CSV文件格式。列顺序应为：country,description,designation,points,rating,people,price");
                return "index";
            }
            
            System.out.println("成功解析 " + ratingList.size() + " 条数据，跳过 " + skipBadLine + " 条无效数据");

            // 三组皮尔逊相关系数
            double corRP = calcCorrelation(ratingList, priceList);
            double corRR = calcCorrelation(ratingList, peopleList);
            double corPP = calcCorrelation(peopleList, priceList);

            // 各指标详细统计
            double avgRating = calculateAverage(ratingList);
            double avgPeople = calculateAverage(peopleList);
            double avgPrice = calculateAverage(priceList);
            double stdRating = calculateStdDev(ratingList, avgRating);
            double stdPeople = calculateStdDev(peopleList, avgPeople);
            double stdPrice = calculateStdDev(priceList, avgPrice);
            double medianRating = calculateMedian(ratingList);
            double medianPrice = calculateMedian(priceList);

            // 整体统计
            int total = ratingList.size();
            double sumAll = 0;
            double max = Double.MIN_VALUE;
            double min = Double.MAX_VALUE;
            for (int i = 0; i < total; i++) {
                double r = ratingList.get(i);
                double p = priceList.get(i);
                double peo = peopleList.get(i);
                sumAll += r + p + peo;
                if (r > max) max = r;
                if (p > max) max = p;
                if (peo > max) max = peo;
                if (r < min) min = r;
                if (p < min) min = p;
                if (peo < min) min = peo;
            }
            double avgAll = sumAll / (total * 3.0);

            // 柱状图数组
            List<String> barLabelList = new ArrayList<>();
            barLabelList.add("评分-价格");
            barLabelList.add("评分-人数");
            barLabelList.add("人数-价格");
            double[] barDataArr = new double[]{corRP, corRR, corPP};

            // 评分分布直方图数组
            Map<Integer, Integer> scoreCount = new HashMap<>();
            for (Double s : ratingList) {
                int key = s.intValue();
                scoreCount.put(key, scoreCount.getOrDefault(key, 0) + 1);
            }
            List<String> histLabelList = new ArrayList<>();
            List<Integer> histValList = new ArrayList<>();
            for (Map.Entry<Integer, Integer> entry : scoreCount.entrySet()) {
                histLabelList.add(entry.getKey() + "分");
                histValList.add(entry.getValue());
            }

            // 散点图数据：评分vs价格
            List<Double> scatterPriceList = new ArrayList<>();
            List<Double> scatterRatingList = new ArrayList<>();
            for (int i = 0; i < Math.min(ratingList.size(), 100); i++) {
                scatterRatingList.add(ratingList.get(i));
                scatterPriceList.add(priceList.get(i));
            }

            // 价格区间分析
            Map<String, Integer> priceRanges = analyzePriceRanges(priceList);
            
            // 评分等级分析
            Map<String, Integer> ratingGrades = analyzeRatingGrades(ratingList);

            model.addAttribute("total", total);
            model.addAttribute("sumAll", sumAll);
            model.addAttribute("avgAll", avgAll);
            model.addAttribute("max", max);
            model.addAttribute("min", min);
            model.addAttribute("corRP", String.format("%.3f", corRP));
            model.addAttribute("corRR", String.format("%.3f", corRR));
            model.addAttribute("corPP", String.format("%.3f", corPP));

            model.addAttribute("barLabelList", barLabelList);
            model.addAttribute("barDataArr", barDataArr);
            model.addAttribute("histLabelList", histLabelList);
            model.addAttribute("histValList", histValList);
            model.addAttribute("scatterRatingList", scatterRatingList);
            model.addAttribute("scatterPriceList", scatterPriceList);
            model.addAttribute("priceRanges", priceRanges);
            model.addAttribute("ratingGrades", ratingGrades);
            model.addAttribute("avgRating", String.format("%.3f", avgRating));
            model.addAttribute("avgPrice", String.format("%.2f", avgPrice));
            model.addAttribute("stdRating", String.format("%.3f", stdRating));
            model.addAttribute("stdPrice", String.format("%.2f", stdPrice));
            model.addAttribute("medianRating", String.format("%.3f", medianRating));
            model.addAttribute("medianPrice", String.format("%.2f", medianPrice));
            model.addAttribute("avgPeople", String.format("%.3f", avgPeople));
            model.addAttribute("stdPeople", String.format("%.3f", stdPeople));
            
            // 添加成功消息
            model.addAttribute("successMsg", "✅ 成功分析 " + total + " 条数据！");
            model.addAttribute("dataQualityMsg", skipBadLine > 0 ? 
                "⚠️ 跳过 " + skipBadLine + " 条格式错误的数据" : "✅ 所有数据格式正确");
            
            model.addAttribute("msg", "ok");
            
            // 存储数据到实例变量（用于Word导出）
            this.totalStore = total;
            this.sumAllStore = sumAll;
            this.avgAllStore = avgAll;
            this.maxStore = max;
            this.minStore = min;
            this.corRPStore = corRP;
            this.corRRStore = corRR;
            this.corPPStore = corPP;
            this.avgRatingStore = avgRating;
            this.avgPriceStore = avgPrice;
            this.medianRatingStore = medianRating;
            this.medianPriceStore = medianPrice;
            
            // 存储数据到Session（用于Word导出）
            session.setAttribute("totalStore", total);
            session.setAttribute("sumAllStore", sumAll);
            session.setAttribute("avgAllStore", avgAll);
            session.setAttribute("maxStore", max);
            session.setAttribute("minStore", min);
            session.setAttribute("corRPStore", corRP);
            session.setAttribute("corRRStore", corRR);
            session.setAttribute("corPPStore", corPP);
            session.setAttribute("avgRatingStore", avgRating);
            session.setAttribute("avgPriceStore", avgPrice);
            session.setAttribute("medianRatingStore", medianRating);
            session.setAttribute("medianPriceStore", medianPrice);
            session.setAttribute("priceRanges", priceRanges);
            session.setAttribute("ratingGrades", ratingGrades);
            
            return "result";
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            if (errorMsg != null && errorMsg.contains("ForInputString")) {
                model.addAttribute("msg", "❌ CSV文件格式错误！请确保包含正确的数值列");
            } else if (errorMsg != null && errorMsg.contains("Index")) {
                model.addAttribute("msg", "❌ CSV列数不足！需要至少7列数据");
            } else {
                model.addAttribute("msg", "❌ 文件处理失败：" + (errorMsg != null ? errorMsg : "未知错误"));
            }
            return "index";
        }
    }

    @GetMapping("/clear")
    public String clear() {
        return "index";
    }
    
    @GetMapping("/export")
    public StreamingResponseBody exportWord(HttpServletResponse response, HttpSession session) {
        response.setContentType("application/msword");
        response.setHeader("Content-Disposition", "attachment; filename=wine_analysis.doc");
        
        return outputStream -> {
            // 从Session获取数据
            Object totalObj = session.getAttribute("totalStore");
            Object sumAllObj = session.getAttribute("sumAllStore");
            Object avgAllObj = session.getAttribute("avgAllStore");
            Object maxObj = session.getAttribute("maxStore");
            Object minObj = session.getAttribute("minStore");
            Object corRPObj = session.getAttribute("corRPStore");
            Object corRRObj = session.getAttribute("corRRStore");
            Object corPPObj = session.getAttribute("corPPStore");
            Object avgRatingObj = session.getAttribute("avgRatingStore");
            Object avgPriceObj = session.getAttribute("avgPriceStore");
            Object medianRatingObj = session.getAttribute("medianRatingStore");
            Object medianPriceObj = session.getAttribute("medianPriceStore");
            
            int total = totalObj != null ? ((Number) totalObj).intValue() : this.totalStore;
            double sumAll = sumAllObj != null ? ((Number) sumAllObj).doubleValue() : this.sumAllStore;
            double avgAll = avgAllObj != null ? ((Number) avgAllObj).doubleValue() : this.avgAllStore;
            double max = maxObj != null ? ((Number) maxObj).doubleValue() : this.maxStore;
            double min = minObj != null ? ((Number) minObj).doubleValue() : this.minStore;
            double corRP = corRPObj != null ? ((Number) corRPObj).doubleValue() : this.corRPStore;
            double corRR = corRRObj != null ? ((Number) corRRObj).doubleValue() : this.corRRStore;
            double corPP = corPPObj != null ? ((Number) corPPObj).doubleValue() : this.corPPStore;
            double avgRating = avgRatingObj != null ? ((Number) avgRatingObj).doubleValue() : this.avgRatingStore;
            double avgPrice = avgPriceObj != null ? ((Number) avgPriceObj).doubleValue() : this.avgPriceStore;
            double medianRating = medianRatingObj != null ? ((Number) medianRatingObj).doubleValue() : this.medianRatingStore;
            double medianPrice = medianPriceObj != null ? ((Number) medianPriceObj).doubleValue() : this.medianPriceStore;
            
            // 生成相关性分析
            String corRPAnalysis = generateCorrelationAnalysis(corRP, "评分", "价格");
            String corRRAnalysis = generateCorrelationAnalysis(corRR, "评分", "评分人数");
            String corPPAnalysis = generateCorrelationAnalysis(corPP, "评分人数", "价格");
            
            // 生成综合结论
            String conclusion = generateComprehensiveConclusion(corRP, corRR, corPP);
            
            String content = "葡萄酒数据评估分析报告\n\n" +
                    "一、整体统计\n" +
                    "有效数据总条数：" + total + "\n" +
                    "全部数值总和：" + String.format("%.2f", sumAll) + "\n" +
                    "数值平均值：" + String.format("%.2f", avgAll) + "\n" +
                    "最大值：" + String.format("%.2f", max) + "\n" +
                    "最小值：" + String.format("%.2f", min) + "\n\n" +
                    "二、详细指标统计\n" +
                    "平均评分：" + String.format("%.3f", avgRating) + "\n" +
                    "平均价格：" + String.format("%.2f", avgPrice) + "\n" +
                    "评分中位数：" + String.format("%.3f", medianRating) + "\n" +
                    "价格中位数：" + String.format("%.2f", medianPrice) + "\n\n" +
                    "三、相关系数分析\n" +
                    "评分与价格相关系数：" + String.format("%.3f", corRP) + "\n" + corRPAnalysis + "\n\n" +
                    "评分与人数相关系数：" + String.format("%.3f", corRR) + "\n" + corRRAnalysis + "\n\n" +
                    "人数与价格相关系数：" + String.format("%.3f", corPP) + "\n" + corPPAnalysis + "\n\n" +
                    "四、评估结论\n" + conclusion + "\n\n" +
                    "报告生成时间：" + new java.util.Date() + "\n" +
                    "葡萄酒数据评估分析系统";
            
            outputStream.write(content.getBytes("UTF-8"));
        };
    }
    
    private String generateCorrelationAnalysis(double correlation, String var1, String var2) {
        String strength = "";
        String direction = "";
        String businessMeaning = "";
        
        if (Math.abs(correlation) >= 0.7) {
            strength = "强";
            if (correlation > 0) {
                businessMeaning = var1 + "与" + var2 + "之间存在极强的正相关关系，" + var1 + "的显著提升会直接带动" + var2 + "的大幅增长。";
            } else {
                businessMeaning = var1 + "与" + var2 + "之间存在极强的负相关关系，" + var1 + "的增加会导致" + var2 + "的显著下降。";
            }
        } else if (Math.abs(correlation) >= 0.4) {
            strength = "中等";
            if (correlation > 0) {
                businessMeaning = var1 + "与" + var2 + "之间存在中等正相关关系，" + var1 + "对" + var2 + "有一定的影响作用。";
            } else {
                businessMeaning = var1 + "与" + var2 + "之间存在中等负相关关系，" + var1 + "的变化会对" + var2 + "产生相反的影响。";
            }
        } else if (Math.abs(correlation) >= 0.2) {
            strength = "弱";
            businessMeaning = var1 + "与" + var2 + "之间存在弱相关关系，虽有统计意义但影响较小。";
        } else {
            strength = "几乎无";
            businessMeaning = var1 + "与" + var2 + "之间几乎不存在线性相关关系，各自变化相对独立。";
        }
        
        direction = correlation > 0 ? "正相关" : "负相关";
        
        return "相关性强度：" + strength + direction + "\n业务含义：" + businessMeaning;
    }
    
    private String generateComprehensiveConclusion(double corRP, double corRR, double corPP) {
        StringBuilder conclusion = new StringBuilder();
        conclusion.append("基于对");
        conclusion.append(this.totalStore > 0 ? this.totalStore : "多");
        conclusion.append("款葡萄酒数据的深度分析，得出以下专业评估结论：\n\n");
        
        if (Math.abs(corRP) >= 0.3) {
            if (corRP > 0) {
                conclusion.append("1. 葡萄酒品质评分与定价策略密切相关（相关系数");
                conclusion.append(String.format("%.3f", corRP));
                conclusion.append("），评分越高的葡萄酒定价越高，体现了'一分价钱一分货'的市场规律。");
            } else {
                conclusion.append("1. 葡萄酒品质评分与定价策略呈现负相关（相关系数");
                conclusion.append(String.format("%.3f", corRP));
                conclusion.append("），这可能反映了市场定价策略的复杂性，品牌溢价、稀缺性等因素发挥了更重要作用。");
            }
            conclusion.append("\n\n");
        }
        
        if (Math.abs(corRR) >= 0.3) {
            if (corRR > 0) {
                conclusion.append("2. 消费者评价行为与葡萄酒品质呈现正相关（相关系数");
                conclusion.append(String.format("%.3f", corRR));
                conclusion.append("），表明消费者更倾向于对高品质葡萄酒进行评价和分享，形成了良性的市场反馈机制。");
            } else {
                conclusion.append("2. 消费者评价行为与葡萄酒品质关联度较低（相关系数");
                conclusion.append(String.format("%.3f", corRR));
                conclusion.append("），建议加强产品互动性和营销策略以提升用户参与度。");
            }
            conclusion.append("\n\n");
        }
        
        if (Math.abs(corPP) >= 0.3) {
            if (corPP > 0) {
                conclusion.append("3. 葡萄酒定价与市场关注度呈正相关（相关系数");
                conclusion.append(String.format("%.3f", corPP));
                conclusion.append("），高价葡萄酒更容易吸引消费者的关注和讨论，反映了高端产品的特殊市场属性。");
            } else {
                conclusion.append("3. 葡萄酒定价与市场关注度关联度不高（相关系数");
                conclusion.append(String.format("%.3f", corPP));
                conclusion.append("），性价比可能是消费者更重要的考虑因素。");
            }
            conclusion.append("\n\n");
        }
        
        conclusion.append("综合建议：\n");
        conclusion.append("- 品质评分是影响定价的核心因素，应持续提升产品品质\n");
        conclusion.append("- 加强与消费者的互动，提升产品知名度和市场影响力\n");
        conclusion.append("- 制定差异化定价策略，平衡品质与市场接受度\n");
        conclusion.append("- 关注市场反馈，及时调整产品定位和营销策略");
        
        return conclusion.toString();
    }

    // 皮尔逊相关系数
    private double calcCorrelation(List<Double> xList, List<Double> yList) {
        int n = xList.size();
        double sumX = 0, sumY = 0, sumXY = 0;
        double sumXX = 0, sumYY = 0;
        for (int i = 0; i < n; i++) {
            double x = xList.get(i);
            double y = yList.get(i);
            sumX += x;
            sumY += y;
            sumXY += x * y;
            sumXX += x * x;
            sumYY += y * y;
        }
        double numerator = n * sumXY - sumX * sumX;
        double dx = n * sumXX - sumX * sumX;
        double dy = n * sumYY - sumY * sumY;
        double denominator = Math.sqrt(dx * dy);
        if (denominator == 0) return 0;
        return numerator / denominator;
    }
    
    private double calculateAverage(List<Double> list) {
        if (list.isEmpty()) return 0;
        double sum = 0;
        for (double val : list) {
            sum += val;
        }
        return sum / list.size();
    }
    
    private double calculateStdDev(List<Double> list, double avg) {
        if (list.isEmpty()) return 0;
        double sum = 0;
        for (double val : list) {
            sum += Math.pow(val - avg, 2);
        }
        return Math.sqrt(sum / list.size());
    }
    
    private double calculateMedian(List<Double> list) {
        if (list.isEmpty()) return 0;
        List<Double> sorted = new ArrayList<>(list);
        Collections.sort(sorted);
        int size = sorted.size();
        if (size % 2 == 0) {
            return (sorted.get(size/2 - 1) + sorted.get(size/2)) / 2.0;
        } else {
            return sorted.get(size/2);
        }
    }
    
    private Map<String, Integer> analyzePriceRanges(List<Double> priceList) {
        Map<String, Integer> ranges = new HashMap<>();
        ranges.put("低端(0-20)", 0);
        ranges.put("中低端(20-50)", 0);
        ranges.put("中端(50-100)", 0);
        ranges.put("中高端(100-200)", 0);
        ranges.put("高端(200-500)", 0);
        ranges.put("奢华(500+)", 0);
        
        for (double price : priceList) {
            if (price < 20) ranges.put("低端(0-20)", ranges.get("低端(0-20)") + 1);
            else if (price < 50) ranges.put("中低端(20-50)", ranges.get("中低端(20-50)") + 1);
            else if (price < 100) ranges.put("中端(50-100)", ranges.get("中端(50-100)") + 1);
            else if (price < 200) ranges.put("中高端(100-200)", ranges.get("中高端(100-200)") + 1);
            else if (price < 500) ranges.put("高端(200-500)", ranges.get("高端(200-500)") + 1);
            else ranges.put("奢华(500+)", ranges.get("奢华(500+)") + 1);
        }
        return ranges;
    }
    
    private Map<String, Integer> analyzeRatingGrades(List<Double> ratingList) {
        Map<String, Integer> grades = new HashMap<>();
        grades.put("优秀(4.5+)", 0);
        grades.put("良好(4.0-4.5)", 0);
        grades.put("中等(3.5-4.0)", 0);
        grades.put("一般(3.0-3.5)", 0);
        grades.put("较差(<3.0)", 0);
        
        for (double rating : ratingList) {
            if (rating >= 4.5) grades.put("优秀(4.5+)", grades.get("优秀(4.5+)") + 1);
            else if (rating >= 4.0) grades.put("良好(4.0-4.5)", grades.get("良好(4.0-4.5)") + 1);
            else if (rating >= 3.5) grades.put("中等(3.5-4.0)", grades.get("中等(3.5-4.0)") + 1);
            else if (rating >= 3.0) grades.put("一般(3.0-3.5)", grades.get("一般(3.0-3.5)") + 1);
            else grades.put("较差(<3.0)", grades.get("较差(<3.0)") + 1);
        }
        return grades;
    }
}