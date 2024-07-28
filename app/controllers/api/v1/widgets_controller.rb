class Api::V1::WidgetsController < Api::V1::ApiController
  def index
    widgets = [
      { id: 1, name: 'Foo' },
      { id: 2, name: 'Bar' },
      { id: 3, name: 'Baz' }
    ]
    render json: widgets
  end
end
