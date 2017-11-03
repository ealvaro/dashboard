Tracker::Application.routes.draw do

  mount JasmineRails::Engine => '/spec' if defined?(JasmineRails)

  constraints({ :subdomain => /dd/ }) do
    resources :driller_surveys, only: [:create, :index]
    get '/' => 'driller_surveys#index'
    get 'auth/new', to: 'driller_sessions#new'
    post 'auth', to: 'driller_sessions#create'
    delete 'auth', to: 'driller_sessions#destroy', as: 'driller_sign_out'
  end
  root to: "pages#home"

  resources :searches, only: :index

  get 'blow_up', to: "application#blow_up"
  resources :receivers, only: [:index, :show]
  resources :mandates do
    member do
      get "receipts"
    end
  end
  resources :software, except: [:index, :show] do
    collection do
      get "overview"
      get "previous"
    end
  end
  get "software/:software_type/latest", to: "software#latest", as: :latest_software

  resources :firmware_updates, except: [:index, :show] do
    member do
      get "confirm_delete"
    end
    collection do
      get "overview"
    end
  end

  resources :users, only: [:show]

  get 'follows' => 'users#follows'
  post 'follow' => 'users#follow'
  post 'unfollow' => 'users#unfollow'

  get 'installs', to: "installs#index", as: :installs

  resources :tools, only: [] do
    get 'histograms', on: :member
  end

  get "tools", to: "tools#tools_list", as: :tools
  get "tools/type/:id", to: "tools#tools", as: :tool_type
  get "tools/list/:id", to: "tools#show", as: :tool
  get "tools/list/:id/events", to: "tools#events", as: :events
  get "tools/:id/merge", to: "tools#merge", as: :merge_tool
  post "tools/:id/merge_tools", to: "tools#merge_tools"
  get "events/:id", to: "events#show", as: :event
  delete "tools/:id", to: "tools#destroy", as: :delete_tool

  get "/survey_imports" => "surveys#imports", as: :survey_imports
  delete "/survey_imports/:id" => "surveys#delete_run", as: :survey_import_run

  get "jobs/:job_id/surveys" => "surveys#job", as: :surveys_by_job
  get "jobs/:job_id/surveys/clip" => "surveys#clip", as: :clip_surveys_by_job
  post "jobs/:job_id/surveys/clip/:job_id" => "surveys#apply_clip", as: :apply_clip_surveys_by_job
  get "jobs/:job_id/surveys/export" => "surveys#export_job", as: :export_surveys_by_job
  resources :surveys, except: [:edit, :update] do
    collection do
      get :corrections
      post  :apply_corrections
    end
    member do
      post :ignore
      patch :apply
      get :edit_approval
      post :update_approval
    end
  end

  get 'jobs/:id/show_receiver', to: 'jobs#show_receiver', as: :active_job_dashboard
  get 'jobs/:id/show_receiver_settings', to: 'jobs#show_receiver_settings', as: :show_receiver_settings

  scope '/billing' do
    root to: "billing_dashboard#show", as: :billing_root

    resources :imports, except: [:show] do
      get 'run', to: 'imports#run'
    end

    get "clients/:client_id/current_scheme", to: "pricing_schemes#current_scheme", as: "current_scheme"
    resources :pricing_schemes, only:[:show]

    resources :run_records, only: [:show] do
      resources :images, only: [:new, :index]
    end
    resources :invoices, only: [:new, :edit, :index, :show] do
      get '/to-draft', to: 'invoices#to_draft', as: "to_draft"
    end
    resources :images, only: [:create, :destroy]
  end

  namespace :billing do
    resources :tools, only: [:index, :show]
  end
  get 'billing/tools/:tool_id/run_records', to: 'run_records#index', as: 'billing_tool_run_records'

  resources :runs do
    resources :run_records, only: [:index]
    get 'search' => 'runs#search', on: :collection
  end

  resources :jobs do
    resources :runs, only: [:index, :new]
    get 'search' => 'jobs#search', on: :collection
  end

  resources :clients, except: [:delete] do
    get 'search' => 'clients#search', on: :collection
    put 'ignore' => 'clients#ignore', on: :member
  end

  resources :wells do
    get 'search' => 'wells#search', on: :collection
  end

  resources :formations, except: [:destroy] do
    get 'search' => 'formations#search', on: :collection
  end

  resources :defects, only: [:index, :create, :new]

  resources :notifiers, except: [:create] do
    collection do
      get :updates_fields
    end
  end

  resources :global_notifiers, only: [:index, :create]
  resources :group_notifiers, only: [:index, :create]
  resources :rig_notifiers, only: [:index, :create]
  resources :template_notifiers, only: [:index, :create]
  resources :templates, only: [:index, :create, :destroy, :update, :edit, :new] do
    post 'clone'
    post 'import'
  end

  namespace :admin do
    root to: "dashboard#show", as: :admin_root
    resources :users
    resources :software_types, except: [:show]
    resources :regions, except: [:show, :delete]
    resources :report_types do
      resources :documents, shallow: true
    end
    resources :documents, except: [:index, :new]
  end

  namespace :push do
    get 'current_user', to: 'users#logged_in_user'
    resources :clients, only: [:index, :show]
    get '/jobs/search', to: 'jobs#search'
    get 'jobs/active/:id' => 'jobs#active'
    resources :invoices
    resources :pricing_schemes, only: [:show, :update]
    resources :receivers, only: [:index, :create]
    resources :jobs, only:[:index, :create, :show, :update, :destroy] do
      get 'search_all', on: :collection
      get 'recent_updates', on: :member
      get 'invoices', to: 'jobs#invoices'
      get 'mark_inactive', on: :member
      get 'mark_active', on: :member
    end
    resources :formations, only: [:index]
    resources :runs, only: [:show, :index]
    resources :report_types, only: [:index]
    resources :users, only: [:index, :update, :destroy, :show] do
      get 'permissions', on: :collection
      get 'alert_users', on: :collection
      post 'export_csv', on: :collection
    end

    resources :alerts, only: [:index] do
      put 'ignore', to: 'alerts#ignore'
      put 'complete', to: 'alerts#complete'
      collection do
        get 'test', to: 'alerts#test'
      end
    end

    resources :subscriptions, only: [:destroy, :create]
    resources :threshold_settings, only: [:create]
    resources :truck_requests, only: [:index, :create, :update]
  end

  namespace :v700 do
    get 'jobs/check'
    post 'jobs/create'
    resources :mandates, only: [:index]
    resources :tools, only:[] do
      resources :events, only: [:create]
    end
    #TODO: This route is for testing only
    post 'events/create'
  end

  resources :report_requests, only: [:new, :create, :index, :show] do
    get 'recently_completed', on: :collection
    get 'all', on: :collection
  end

  namespace :v710 do
    resources :report_requests, only: [:create, :index] do
      put 'respond'
    end

    resources :tools, only: [:create]

    get  'jobs/active'
    post 'jobs/receiver_updates'
    post 'jobs/logger_updates'

    post 'tools/events', to: "events#create"
  end

  post "v710/jobs/:id/test_receiver_btr", to: "v710/jobs#test_receiver_btr", as: "test_receiver_btr"
  post "v710/jobs/:id/test_receiver_leam", to: "v710/jobs#test_receiver_leam"
  post "v710/jobs/:id/test_logger", to: "v710/jobs#test_logger"

  namespace :v730 do
    resources :report_requests, only: [:create, :index] do
      put 'respond'
    end

    resources :surveys, only: [:create]
    post 'surveys/update'

    resources :gammas, only: [:create, :update] do
      patch 'request_edit', on: :member
      collection do
        get 'edits'
        patch 'updates'
        post 'test_gamma'
        get 'refresh'
      end
    end

    post 'jobs/receiver_updates'
    post 'jobs/logger_updates'
    get 'jobs/recent'

    post 'logger_updates', to: 'logger_updates#create'
    post 'receiver_updates', to: 'receiver_updates#create'
  end

  namespace :v731 do
    post 'receiver_updates', to: 'receiver_updates#create'
  end

  namespace :v744 do
    post 'logger_updates', to: 'logger_updates#create'
    post 'receiver_updates', to: 'receiver_updates#create'

    resources :receiver_settings, only: [:create, :index, :update]
  end

  namespace :v750 do
    resources :clients, only: [:index, :show, :create, :update, :destroy]
    resources :rigs, only: [:index, :show, :create, :update, :destroy] do
      get 'active', on: :collection
    end
    resources :gammas, only: [] do
      collection do
        patch 'update'
        patch 'updates'
      end
    end

    resources :notifications, only: [:index] do
      put 'complete', on: :collection
      get 'search' => 'notifications#search', on: :collection
    end

    resources :report_requests, only: [] do
      get 'report_data', on: :collection
      put 'respond'
      put 'status'
    end

    get 'tools' => 'tools#tools'
    post 'tools/csv' => 'tools#tools_csv'
    get 'recent_memories' => 'tools#recent_memories'
    post 'recent_memories/csv' => 'tools#memories_csv'
  end

  namespace :v760 do
    resources :histograms, only: [:create, :update]

    post 'receiver_core_updates', to: 'receiver_updates#create_core'
    post 'receiver_pulse_updates', to: 'receiver_updates#create_pulse'
    post 'receiver_fft_updates', to: 'receiver_updates#create_fft'

    resources :tools, only: [:create] do
      post 'new_dumb_tool', on: :collection
    end
  end

  namespace :v770 do
    resources :notifications, only: [:index]
  end

  resources :rigs, only: [:index] do
    get 'active', on: :collection
  end

  resources :rig_groups, except: [:show]
  resources :truck_requests, only: [:index]

  get "rig_groups/:id/rigs", to: "rig_groups#rigs"
  get "rig_groups/:id/notifiers", to: "rig_groups#notifiers"

  post "v710/jobs/:id/test_receiver_btr", to: "v710/jobs#test_receiver_btr"
  post "v710/jobs/:id/test_receiver_leam", to: "v710/jobs#test_receiver_leam"
  post "v710/jobs/:id/test_logger", to: "v710/jobs#test_logger"

  get "push/:client_id/current_scheme", to: "push/pricing_scheme#current_scheme"
  get "push/assets/:id", to: "push/assets#show"
  get "push/driver/mandates"
  post "push/driver/receipts"
  post "push/driver/surveys", to: "push/surveys#create"
  post "push/driver/surveys/batch", to: "push/surveys#batch"
  get "push/driver/firmware", to: "push/firmware#index"
  get "push/driver/software", to: "push/software#index"
  get "push/regions", to: "push/regions#index"
  post "push/installs", to: "push/installs#create"
  get "push/installs", to: "push/installs#index"
  get "push/installs/:id/recent_tools", to: "push/installs#recent_tools"
  get "push/tools", to: "push/tools#index"
  get "push/tools/event_types", to: "push/tools#event_types"
  delete "push/tools/:id", to: "push/tools#destroy"
  post "push/tools", to: "push/tools#create"
  post "push/tools/to_csv", to: "push/tools#to_csv"
  get "push/tools/recent_memories", to: "push/tools#recent_memories"
  get "push/tools/:id", to: "push/tools#show"
  post "push/tools/events", to: "push/tools#events"
  get "push/tools/:id/event_history", to: "push/tools#event_history"

  post "push/users/roles", to: "push/users#roles"

  post "push/receivers/:id/events", to: "push/receivers#events"
  post "push/receivers/:id/test", to: "push/receivers#test"

  post 'push/imports/:id/import_update', to: 'push/imports#import_update'
  get 'push/imports/:id/import_updates', to: 'push/imports#import_updates'

  get 'auth/new', to: 'sessions#new', as: 'new_session'
  post 'auth', to: 'sessions#create', as: 'sessions'
  delete 'auth', to: 'sessions#destroy', as: 'sign_out'
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'application/clean_db', to: 'application#clean_db', as: 'clean_db'
end
