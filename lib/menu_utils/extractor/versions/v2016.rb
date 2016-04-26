require 'csv'
require 'json'

module V2016
  # 献立の日付フォーマットをDateオブジェクトに変換するモンキーパッチ
  module DateFormatter
    def to_formated_date
      Date.new(Date.today.year, self.split("月")[0].tr("０-９","0-9").to_i, self.split("月")[1].tr("０-９","0-9").to_i)
    end
  end

  module Base
    attr_reader :csv, :dish_ranges, :meal_dates, :version

    def initialize(path)
      @csv_path    = path
      @csv         = CSV.read(path, {headers: extract_header})
      @dish_ranges = extract_ranges
      @meal_dates  = extract_dates
      @version     = "v2016"
    end

    # 献立の展開オブジェクト(自身)が有効かどうか
    def valid?
      @dish_ranges.present? && @csv.headers.instance_of?(Array)
    end

    # 指定した日付文字列の献立が含まれる献立範囲(CSVの行数からなるRangeオブジェクト)の配列を返す
    def meals_on date
      @dish_ranges.select{ |r| @csv.by_col[date][r].join.match(/.+[\d|\.].*/) }
    end

    # 日付文字列と献立範囲から1食分の栄養を含むセルの文字列の配列を返す
    def nutrients_of(date, range)
      index = @csv.headers.index(date)
      @csv.by_col[index..index+3][range].select{ |menu| menu.join =~ /\d+/}.last
    end

    # 日付文字列と献立範囲から献立名とカロリー(カロリーはv2015との互換性維持のため/値はnil)の組の配列を返す
    def dishes_of(date, range)
      index = @csv.headers.index(date)
      [@csv.by_col[index][range], Array.new(range.size)].transpose
        .reject{ |menu| menu[0].nil? }
        .reject{ |menu| menu[0] =~ /\d+/}
    end

    # 1食分の栄養素の文字列から指定した栄養素の数値を返す
    def value_of(nutrient, nutrient_type)
      case nutrient_type
      when :calorie;      nutrient[0].to_i
      when :protein;      nutrient[1].to_i
      when :fat;          nutrient[2].to_i
      when :carbohydrate; nil
      when :salt;         nutrient[3].to_f
      else; nil
      end
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
      @csv.headers.select{ |e| e&.tr("０-９","0-9") =~ /\d+月\d+.*/ }
    end
  end
end
