RSpec.describe KeywordMatcher do
  it 'has a version number' do
    expect(KeywordMatcher::VERSION).not_to be nil
  end

  shared_examples 'matches' do |samples, keyword|
    samples.each do |sample, result|
      it "equals #{result} for #{sample}" do
        expect(described_class.matched?(keyword, sample)).to eq(result)
      end
    end
  end

  describe '.matched?' do
    context 'basic keyword' do
      it_behaves_like 'matches', {
        'молоко рыба кошка' => true,
        'молоко рыба кошко' => true,
        'кошка молоко рыба' => true,
        'кот молоко риба' => false,
        'молоко рыба' => false
      }, "молоко мол\n\nрыба\nкошка   кош\n\n"
    end

    context 'keyword with not and or' do
      it_behaves_like 'matches', {
        'НЕKТАР/1Л/RICH' => true,
        'RICH 1л Нектар ДОБРЫЙ Яблоко-персик 0,33 л т/п' => false,
        'ДОБРЫЙ Яблоко-персик 990мл т/п' => true
      }, "рич rich \n1л\nИЛИ\n добрый добр\n 0.99л 990мл \nНЕ\n добрый добр \n0.33л 330мл"
    end

    context 'keyword with gram' do
      it_behaves_like 'matches', {
        'Соус Кальве Сливочно-Чесночный Д/Мяса 230г Дой/Пак' => true
      }, "Calve Кальве\nсливочно-чесночный\n230гр 0.23кг"
    end

    context 'keyword precise' do
      it_behaves_like 'matches', {
        'Соус Кальве Сливочно-Чесночный Д/Мяса 230г Дой/Пак' => true,
        'Соус Кальве Сливочно-Чесночныл Д/Мяса 230г Дой/Пак' => false
      }, "'сливочно-чесночный'"
    end

    context 'keyword fuzzy' do
      it_behaves_like 'matches', {
        'Соус Кальве Сливочно-Чесночныл Д/Мяса 230г Дой/Пак' => true
      }, 'сливочно-чесночный'
    end

    context 'keyword with measures' do
      it_behaves_like 'matches', {
        'молоко рыба' => false,
        '6*88557 Сок RICH мультифрут 1л' => true,
        '4* 38407 Нектар RICH вишневый 1.0л' => true,
        '1*3447796 Нектар RICH из апельсинов 1л' => true,
        'РИЧ нектар Манго-Апельсин 1л т/пак(Мултон)' => true,
        'РИЧ сок виноградный 1л (Мултон) :12' => true,
        'СОК РИЧ 1Л ЯБЛОЧНЫЙ 100%' => true
      }, "Rich Рич\n1л"
    end

    context 'keyword with coffee' do
      it_behaves_like 'matches', { 'Кофе Двойной Капучино 300 Мл' => true }, 'кофе капуччино'
    end

    context 'keyword with activia' do
      it_behaves_like 'matches', { 'Йогурт Активиа Пит.2,2% Злаки' => true }, 'Активия'
    end
  end
end