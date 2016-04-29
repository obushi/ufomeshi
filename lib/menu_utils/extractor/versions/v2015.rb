require 'csv'
require 'json'

class V2015
  attr_reader :csv, :dish_ranges, :meal_dates, :version

  def initialize(path)
    @csv_path    = path
    @csv         = CSV.read(path, {headers: extract_header})
    @dish_ranges = extract_ranges
    @meal_dates  = extract_dates
    @version     = "v2015"
  end

  # 献立の展開オブジェクト(自身)が有効かどうか
  def valid?
    @dish_ranges.present? && @csv.headers.instance_of?(Array)
  end

  # 指定した日付文字列の献立が含まれる献立範囲(CSVの行数からなるRangeオブジェクト)の配列を返す
  def meals_on date
    @dish_ranges.select{ |r| @csv.by_col[date][r].join.include?("KC") }
  end

  # 日付文字列と献立範囲から1食分の栄養を含むセルの文字列を返す
  def nutrients_of(date, range)
    daily_dishes = daily_dishes_on(date)
    daily_dishes[0][range].select{ |menu| menu =~ /\d+KC.*た\d+.*脂\d+.*炭\d+.*塩\d+\.\d+/ }.first
  end

  # 日付文字列と献立範囲から献立名とカロリーの組の配列を返す
  def dishes_of(date, range)
    daily_dishes = daily_dishes_on(date)
    [daily_dishes[0][range], daily_dishes[1][range]].transpose
    .reject{ |menu| menu[1].nil? }
    .select{ |menu| menu[1] =~ /([1-9]|\d{2,})+KC/ }
    .reject{ |menu| menu[0].nil? }
    .map{ |menu| [menu[0].gsub(/(\s|　)+/, ""), menu[1][/(\d+)KC/, 1].to_i]}
  end

  # 1食分の栄養素の文字列から指定した栄養素の数値を返す
  def value_of(nutrient, nutrient_type)
    case nutrient_type
    when :calorie;      nutrient[/(\d+)KC/, 1].to_i
    when :protein;      nutrient[/た(\d+)/, 1].to_i
    when :fat;          nutrient[/脂(\d+)/, 1].to_i
    when :carbohydrate; nutrient[/炭(\d+)/, 1].to_i
    when :salt;         nutrient[/塩(\d+\.\d+)/, 1].to_f
    else; nil
    end
  end

  # 献立の日付フォーマットをDateオブジェクトに変換する
  def to_date date
    Date.new(Date.today.year, date.split("/")[0].to_i, date.split("/")[1].to_i)
  end

  protected

  # 与えられた配列の全要素が含まれるかを判定する正規表現を返す
  def include_all arr
    /(?=.*#{arr.join(')(?=.*')})/
  end

  # CSVを読み込み,日付を含む行を文字列の配列として返す
  def extract_header
    week_days = %w(日 月 火 水 木 金 土)
    CSV.read(@csv_path).to_a.select{ |e| e.join =~ include_all(week_days) }.first
  end

  # 献立の朝/昼/夕食の献立範囲(CSVの行数からなるRangeオブジェクト)を返す
  def extract_ranges
    head   = []
    ranges = []
    meal_types = %w(朝 昼 夕)
    @csv.to_a.transpose.select{ |e| e.join =~ include_all(meal_types) }.first&.each_with_index do |m, i|
      head << i-1 if m =~ /.*[[朝|昼|夕].*食]|合.*計.*/
    end
    head.each_cons(2) do |arr|
      ranges << Range.new(arr[0], arr[1]-1)
    end
    ranges
  end

  # 献立の日付文字列を含む行から新たに日付文字列の配列を抽出し返す
  def extract_dates
    @csv.headers.select{ |e| e =~ /\d+\/\d+/ }
  end

  # 日付文字列から献立名とカロリーを含む列の全組の配列を返す
  def daily_dishes_on date
    [@csv.by_col[@csv.headers.index(date)].to_a, @csv.by_col[@csv.headers.index(date) + 2].to_a]
  end
end
