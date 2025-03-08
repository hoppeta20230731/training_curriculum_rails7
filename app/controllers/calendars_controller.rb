class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    # binding.pry
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
    # 日曜日は0

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []
    # 最終的に得たい配列：今日から1週間の全ての予定

    plans = Plan.where(date: @todays_date..@todays_date + 6)
    # Planデータベースから7日分のデータ取得

    # 7.times do |x| # 7回繰り返して1日ごとの予定をすべて抜き出す
    #   today_plans = [] # 1日分のすべての予定として配列定義
    #   plans.each do |plan| # 今日から7回分すべて
    #     today_plans.push(plan.plan) if plan.date == @todays_date + x # 今日＋xの日なら、配列にぶちこむ
    #   end
    #   days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, :plans => today_plans, :wday => wdays[(@todays_date+x).wday]} # 曜日を数値で返す（日曜は0：最初に設定した配列と照合）、planのみ配列
    #   @week_days.push(days) # 最終配列にハッシュ（4種）を代入
    # end
    
    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      # wday_num = (@todays_date.wday + x) % 7
      # 6以下ならそのまま返される。

      wday_num = @todays_date.wday + x # wdayメソッドを用いて取得した数値
      if wday_num >= 7 #「wday_numが7以上の場合」という条件式
        wday_num = wday_num -7
      end

      days = { :month => (@todays_date + x).month, :date => (@todays_date + x).day, :plans => today_plans, :wday => wdays[wday_num]}
      @week_days.push(days)
    end
  end
end
